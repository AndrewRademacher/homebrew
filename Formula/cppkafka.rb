class Cppkafka < Formula
    desc "Modern C++ Apache Kafka client library (wrapper for librdkafka)"
    homepage "https://github.com/mfontanini/cppkafka"
    url "https://github.com/AndrewRademacher/cppkafka/archive/v0.2.tar.gz"
    sha256 "4bba8f98d1996b4f87c2036afd8a973ed06881c155b0061a827935b563a0a469"
    head "https://github.com/mfontanini/cppkafka.git"

    # bottle do
    #     cellar :any
    # end

    depends_on "cmake" => :build
    depends_on "boost" => :build
    depends_on "librdkafka"

    def install
        ENV["CMAKE_LIBRARY_PATH"] = "/usr/local/lib"
        ENV["CMAKE_INCLUDE_PATH"] = "/usr/local/include"
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