/* pch.hpp: Precompiled header for TOL project
                GNU/TOL Language.

   Copyright (C) 2003-2024, Bayes Decision, SL (Spain [EU])

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
   USA.
*/

#ifndef TOL_PCH_HPP
#define TOL_PCH_HPP

// C++ Standard Library headers commonly used in TOL
#include <algorithm>
#include <array>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <deque>
#include <exception>
#include <fstream>
#include <functional>
#include <iomanip>
#include <iostream>
#include <iterator>
#include <limits>
#include <list>
#include <map>
#include <memory>
#include <new>
#include <numeric>
#include <queue>
#include <set>
#include <sstream>
#include <stack>
#include <stdexcept>
#include <string>
#include <typeinfo>
#include <utility>
#include <vector>

// Platform-specific includes
#ifdef _WIN32
  #include <windows.h>
#else
  #include <unistd.h>
  #include <sys/types.h>
  #include <sys/stat.h>
#endif

// POSIX compatibility
#if defined(_GNU_SOURCE) || defined(_BSD_SOURCE) || defined(__APPLE__)
  #include <strings.h>  // For strcasecmp, strncasecmp, strcasestr
#endif

#endif // TOL_PCH_HPP