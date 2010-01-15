# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/scotch/scotch-5.1.7.ebuild,v 1.1 2010/01/15 22:43:52 patrick Exp $

EAPI="2"

inherit eutils

DESCRIPTION="Software package and libraries for graph partitioning, static mapping, and sparse matrix block ordering"
HOMEPAGE="http://www.labri.u-bordeaux.fr/perso/pelegrin/scotch/"
SRC_URI="http://gforge.inria.fr/frs/download.php/23390/${PN}_${PV}.tgz"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mpi"

DEPEND="sys-devel/bison
	mpi? ( virtual/mpi )"
RDEPEND="${DEPEND}"

S=${WORKDIR}"/scotch_5.1/src"

src_prepare() {
	epatch "${FILESDIR}"/shared-libs_${PV}.patch
	epatch "${FILESDIR}"/metis-header.patch
}

src_configure() {
	cp "${FILESDIR}"/Makefile.inc_${PV} ./Makefile.inc
}

src_compile() {
	emake -j1 || die "make failed"
	use mpi && (emake -j1 ptscotch || die "make failed")
}

src_install() {
	dodir "/usr"
	emake prefix="${D}/usr" install

	use mpi && dobin "${S}"/../bin/{dgord,dgscat,dgtst}

	for file in `ls "${D}"/usr/bin`
	do
		mv "${D}/usr/bin/$file" "${D}/usr/bin/scotch_$file"
	done

	for file in `ls "${D}"/usr/share/man/man1`
	do
		mv "${D}/usr/share/man/man1/$file" "${D}/usr/share/man/man1/scotch_$file"
	done

	dolib.so "${S}"/{libscotch,libscotchmetis}/*.so
	if [ "$(get_libdir)" != "lib" ]; then
		mv "${D}"/usr/lib/* "${D}"/usr/$(get_libdir)
		rm -rf "${D}"/usr/lib
	fi

	insinto /usr/include/scotch
	doins "${S}"/libscotch/*.h

	insinto /usr/include/scotchmetis
	doins "${S}"/libscotchmetis/*.h

	mv "${D}"/usr/include/*scotch*.h "${D}"/usr/include/scotch/

	insinto "/usr/share/${PN}/tgt"
	doins "${S}"/../tgt/*
	insinto "/usr/share/${PN}/grf"
	doins "${S}"/../grf/*

	cd "${S}/../doc"
	dodoc *.pdf
}
