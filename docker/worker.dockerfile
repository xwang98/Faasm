FROM shillaker/faasm-base

# Set up dummy networking files
WORKDIR /faasm/code/ansible
RUN ansible-playbook net_files.yml

# Build the worker binary
WORKDIR /faasm/code/build
RUN cmake -DCMAKE_CXX_COMPILER=/usr/bin/clang++ -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_BUILD_TYPE=Release ..
RUN cmake --build . --target worker

# Set up entrypoint (for cgroups, namespaces etc.)
COPY docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD "/faasm/code/build/bin/worker"
