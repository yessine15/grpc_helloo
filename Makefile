CXXFLAGS += -std=c++20



ifeq ($(SYSTEM),nadiros)

LDFLAGS += -L/usr/local/lib `pkg-config --libs protobuf grpc++ `\

        -ldl



else

LDFLAGS = -L/recipe-sysroot/usr/bin  `pkg-config --libs protobuf grpc++ `\

           -Wl,--no-as-needed -lgrpc++_reflection -Wl,--as-needed\

           -ldl



endif



PROTOC = protoc

CPPFLAGS += `pkg-config --cflags protobuf grpc`





GRPC_CPP_PLUGIN = grpc_cpp_plugin

GRPC_CPP_PLUGIN_PATH ?= `which $(GRPC_CPP_PLUGIN)`



all: greeter_client greeter_server



greeter_client: helloworld.pb.o helloworld.grpc.pb.o greeter_client.o

        $(CXX) $^ $(LDFLAGS) -o $@



greeter_server: helloworld.pb.o helloworld.grpc.pb.o greeter_server.o

        $(CXX) $^ $(LDFLAGS) -o $@

%.grpc.pb.cc: %.proto

        $(PROTOC) -I $(PROTOS_PATH) --grpc_out=. --plugin=protoc-gen-grpc=$(GRPC_CPP_PLUGIN_PATH) $<



%.pb.cc: %.proto

