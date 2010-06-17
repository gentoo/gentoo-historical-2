# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/mpi/mpi-2.0-r1.ebuild,v 1.1 2010/06/17 02:20:55 jsbronder Exp $

EAPI=2

DESCRIPTION="Virtual for Message Passing Interface (MPI) v2.0 implementation"
HOMEPAGE=""
SRC_URI=""
LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE="cxx fortran romio"

RDEPEND="|| (
	sys-cluster/openmpi[cxx?,fortran?,romio?]
	sys-cluster/mpich2[cxx?,fortran?,romio?]
)"

DEPEND=""
