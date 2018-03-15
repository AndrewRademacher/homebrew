class Cppkafka < Formula
    desc "Modern C++ Apache Kafka client library (wrapper for librdkafka)"
    homepage "https://github.com/mfontanini/cppkafka"
    url "https://github.com/mfontanini/cppkafka/archive/v0.1.tar.gz"
    sha256 "710e442bba8d30bb9501a98e1d4ddc2c7f78c7c3b8bfb9815c793853ab90cbe8"
    head "https://github.com/mfontanini/cppkafka.git"

    # bottle do
    #     cellar :any
    # end

    depends_on "cmake" => :build
    depends_on "librdkafka"

    def install
        system "cmake", ".", *std_cmake_args
        system "make", "install"
    end

    test do
        (testpath/"test.cpp").write <<~EOS
            #include <cppkafka/producer.h>

            using namespace std;
            using namespace cppkafka;
            
            int main() {
                Configuration config = {
                    { "metadata.broker.list", "127.0.0.1:9092" }
                };
            
                // Create the producer
                Producer producer(config);
            }
        EOS
        system ENV.cc, "test.cpp", "-L#{lib}", "-lcppkafka", "-lrdkafka", "-lz", "-lpthread", "-o", "test"
        system "./test"
    end
end