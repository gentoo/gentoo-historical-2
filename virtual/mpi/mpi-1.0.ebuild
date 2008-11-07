# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/mpi/mpi-1.0.ebuild,v 1.4 2008/11/07 04:37:27 jsbronder Exp $

DESCRIPTION="Virtual for Message Passing Interface (MPI) implementation"
HOMEPAGE="http://www.gentoo.org/proj/en/cluster/"
SRC_URI=""
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""
RDEPEND="|| (
		sys-cluster/openmpi
		sys-cluster/mpich2
		sys-cluster/lam-mpi
		sys-cluster/mpich
	)"
DEPEND=""
