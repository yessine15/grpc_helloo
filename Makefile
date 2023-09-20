CXXFLAGS += -std=c++20
ifeq ($(SYSTEM),nadiros)
LDFLAGS += -L/usr/local/lib `pkg-config --libs protobuf grpc++ `\
^I-ldl
else
LDFLAGS = -L/recipe-sysroot/usr/bin  `pkg-config --libs protobuf grpc++ `\
^I-Wl,--no-as-needed -lgrpc++_reflection -Wl,--as-needed\
^I-ldl
endif
PROTOC = protoc
CPPFLAGS += `pkg-config --cflags protobuf grpc`
GRPC_CPP_PLUGIN = grpc_cpp_plugin
GRPC_CPP_PLUGIN_PATH ?= `which $(GRPC_CPP_PLUGIN)
all: greeter_client greeter_server
greeter_client: helloworld.pb.o helloworld.grpc.pb.o greeter_client.o
^I$(CXX) $^ $(LDFLAGS) -o $@
greeter_server: helloworld.pb.o helloworld.grpc.pb.o greeter_server.o
^I$(CXX) $^ $(LDFLAGS) -o $@
%.grpc.pb.cc: %.proto
^I$(PROTOC) -I $(PROTOS_PATH) --grpc_out=. --plugin=protoc-gen-grpc=$(GRPC_CPP_PLUGIN_PATH) $<
%.pb.cc: %.proto
^I$(PROTOC) -I $(PROTOS_PATH) --cpp_out=. $<
clean:
^Irm -f *.o *.pb.cc *.pb.h greeter_client greeter_server

