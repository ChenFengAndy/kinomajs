#
#     Copyright (C) 2010-2015 Marvell International Ltd.
#     Copyright (C) 2002-2010 Kinoma, Inc.
#
#     Licensed under the Apache License, Version 2.0 (the "License");
#     you may not use this file except in compliance with the License.
#     You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#     Unless required by applicable law or agreed to in writing, software
#     distributed under the License is distributed on an "AS IS" BASIS,
#     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#     See the License for the specific language governing permissions and
#     limitations under the License.
#
cmake_minimum_required(VERSION 2.8)
project(kprconfig)

set(XS_TARGET XSCONFIG)

set(CMAKE_C_FLAGS "${BASE_CMAKE_C_FLAGS} -D${XS_TARGET}")
set(CMAKE_C_FLAGS_DEBUG "-DmxDebug=1 -g -O1 -Wall")
set(CMAKE_C_FLAGS_RELEASE "-O3")

set(XSC_BASE_OPTIONS -t ${XS_TARGET} -o ${GRAMMAR_DIR})
set(XSC_OPTIONS_DEBUG ${XSC_BASE_OPTIONS} -d -v)
set(XSC_OPTIONS_RELEASE ${XSC_BASE_OPTIONS})
set(XSC_OPTIONS ${XSC_OPTIONS_${CMAKE_BUILD_TYPE}})

set(SRC_DIR ${XS_HOME}/sources/${PROJECT_NAME})

set(sources ${SRC_DIR}/xsTool.c)

XSC(xs_source ${SRC_DIR}/${PROJECT_NAME}.xs ${GRAMMAR_DIR})
list(APPEND sources ${xs_source})

add_executable(${PROJECT_NAME} ${sources})
set(link_libraries xs)
if (${CMAKE_SYSTEM_NAME} STREQUAL "Linux")
	list(APPEND link_libraries -lm -lnsl)
endif ()
target_link_libraries(${PROJECT_NAME} ${link_libraries})

# vim: set ft=cmake:
