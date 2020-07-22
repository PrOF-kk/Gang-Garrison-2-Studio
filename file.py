#! python3

# PrOF 2020

import os
import re

dirList = ["objects", "rooms", "scripts"]

replaceList = [
	"append_file_to_buffer",
	"buffer_bytes_left",
	"buffer_clear",
	"buffer_create",
	"buffer_destroy",
	"buffer_set_readpos",
	"buffer_size",
	"ip_lookup_create",
	"ip_lookup_destroy",
	"ip_lookup_has_next",
	"ip_lookup_next_result",
	"ip_lookup_ready",
	"read_byte",
	"read_intwrite_uint",
	"read_short",
	"read_string",
	"read_ubyte",
	"read_uint",
	"read_ushort",
	"set_little_endian",
	"set_little_endian_global",
	"socket_accept",
	"socket_connecting",
	"socket_destroy",
	"socket_destroy_abortive",
	"socket_error",
	"socket_has_error",
	"socket_receivebuffer_size",
	"socket_remote_ip",
	"socket_send",
	"tcp_connect",
	"tcp_eof",
	"tcp_listen",
	"tcp_receive",
	"tcp_receive_available",
	"tcp_send",
	"udp_send",
	"write_buffer",
	"write_buffer_part",
	"write_buffer_to_file",
	"write_byte",
	"write_int",
	"write_short",
	"write_string",
	"write_ubyte",
	"write_uint",
	"write_ushort",
]
totcount = 0
for dir in dirList:
	os.chdir(dir)

	for filename in os.listdir("."):

		if os.path.isdir(filename):
			continue

		print("-----------------------")
		print(dir + "/" + filename)
		print("-----------------------")

		count = 0
		with open(filename, "r+") as file:
			data = file.read()
			for keyword in replaceList:
				#count += data.count(keyword)
				#data = data.replace(keyword, "fct_" + keyword)
				pattern = r'\b' + keyword + r'\b'
				(newdata, newcount) = re.subn(pattern, "fct_" + keyword, data)
				data = newdata
				count += newcount

			file.seek(0)
			file.write(data)
			file.truncate()
		totcount += count
		print("Replaced " + str(count) + " keywords")
	os.chdir("..")
print("Replaced in total " + str(totcount) + " keywords")