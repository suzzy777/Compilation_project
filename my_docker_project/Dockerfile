FROM maven:3.8.6-openjdk-8

# Install Java 11 and 17
RUN apt-get update && apt-get install -y openjdk-11-jdk openjdk-17-jdk && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /workspace
COPY . .

# Make scripts executable
RUN chmod +x super_script.sh step_one.sh step_two.sh step_three.sh step_four.sh

ENTRYPOINT ["./super_script.sh"]
CMD ["https://github.com/Adyen/adyen-java-api-library", "6fb5cd049b57a22d2ec4465d204c15f1c90dd325", "."]
