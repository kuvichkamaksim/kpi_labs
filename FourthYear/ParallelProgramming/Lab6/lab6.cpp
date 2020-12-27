#include <iostream>
#include <ctime>
// #include "omp.h"
#include "/usr/local/Cellar/gcc/10.2.0/lib/gcc/10/gcc/x86_64-apple-darwin18/10.2.0/include/omp.h"
#include "mpi.h"

int main(int argc, char** argv) {
    srand(time(NULL));
    const int MATRIX_DIMENSION = 5;
    const int MASTER_RANK = 0;

    // rank - curent process sequence number
    // size - total processes count
    int rank, size, tag = 10;
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Status status;

    if (rank == MASTER_RANK) {
        // Code that will be executed only by the master process
        // Generating of random matrix inside master process
        int master_matrix[MATRIX_DIMENSION][MATRIX_DIMENSION];
        for (int i = 0; i < MATRIX_DIMENSION; i++) {
            for (int j = 0; j < MATRIX_DIMENSION; j++) {
                master_matrix[i][j] = rand() % 100;
                std::cout << master_matrix[i][j] << "\t";
            }
            std::cout << std::endl;
        }
        std::cout << std::endl;

        // Sending copies of the matrix to the different processes
        for (int i = 0; i < MATRIX_DIMENSION; i++) {
            int matrix_copy[MATRIX_DIMENSION][MATRIX_DIMENSION];
            std::copy(&master_matrix[0][0], &master_matrix[0][0] + MATRIX_DIMENSION * MATRIX_DIMENSION, &matrix_copy[0][0]);
            MPI_Send(matrix_copy, MATRIX_DIMENSION * MATRIX_DIMENSION, MPI_INT, i + 1, tag, MPI_COMM_WORLD);
        }
        
        // Receiving the results with the mirrored rows from these processes
        int mirrored_rows[MATRIX_DIMENSION][MATRIX_DIMENSION / 2];
        for (int i = 0; i < MATRIX_DIMENSION; i++) {
            MPI_Recv(mirrored_rows + i, MATRIX_DIMENSION / 2, MPI_INT, i + 1, tag, MPI_COMM_WORLD, &status);
            // Writing the mirrored row to matrix
            for (int j = 0; j < MATRIX_DIMENSION / 2; j++) {
                master_matrix[i][j] = mirrored_rows[i][j];
            }
        }

        // Printing random matrix
        for (int i = 0; i < MATRIX_DIMENSION; i++) {
            for (int j = 0; j < MATRIX_DIMENSION; j++) {
                std::cout << master_matrix[i][j] << "\t";
            }
            std::cout << std::endl;
        }
    } else {
        // Code that will be executed by all processes except master
        // Reseiving the copy of the matrix from the master process
        int received_matrix[MATRIX_DIMENSION][MATRIX_DIMENSION];
        MPI_Recv(received_matrix, MATRIX_DIMENSION * MATRIX_DIMENSION, MPI_INT, MASTER_RANK, tag, MPI_COMM_WORLD, &status);

        // Parallel calculation of the mirrored row on [rank - 1] position
        int mirrored_row[MATRIX_DIMENSION / 2];

        // shared      - shared variables
        // num_threads - number of the threads that will execute the region
        #pragma omp parallel shared(received_matrix) num_threads(MATRIX_DIMENSION)
        {
            #pragma omp for
            for (int i = 0; i < MATRIX_DIMENSION / 2; i++) {
                mirrored_row[i] = received_matrix[rank - 1][MATRIX_DIMENSION - i - 1];
            }
        }

        MPI_Send(mirrored_row, MATRIX_DIMENSION / 2, MPI_INT, MASTER_RANK, tag, MPI_COMM_WORLD);
    }

    MPI_Finalize();
    return 0;
}