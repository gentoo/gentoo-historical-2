# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/db/db-3.2.9-r11.ebuild,v 1.12 2007/09/03 17:07:56 caleb Exp $

inherit gnuconfig libtool eutils db java-pkg-opt-2

DESCRIPTION="Berkeley DB for transaction support in MySQL"
HOMEPAGE="http://www.sleepycat.com/"
SRC_URI="ftp://ftp.sleepycat.com/releases/${P}.tar.gz"

LICENSE="DB"
SLOT="3"
# This ebuild is to be the compatibility ebuild for when db4 is put
# in the tree.
KEYWORDS="~alpha amd64 arm ~hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="doc java"

DEPEND="${RDEPEND}
	=sys-libs/db-1.85*
	sys-devel/libtool
	sys-devel/m4
	java? ( >=virtual/jre-1.4 )"
# We need m4 too else build fails without config.guess

# This doesn't build without exceptions
export CXXFLAGS="${CXXFLAGS/-fno-exceptions/-fexceptions}"

src_unpack() {
	unpack ${A}

	use java && export JAVACABS=${JAVAC}
	use java && export JAVACFLAGS=$(java-pkg_javac-args)

	chmod -R ug+w *

	cd ${WORKDIR}/${P}
	epatch ${FILESDIR}/patch.3.2.9.1
	epatch ${FILESDIR}/patch.3.2.9.2

	# Get db to link libdb* to correct dependencies ... for example if we use
	# NPTL or NGPT, db detects usable mutexes, and should link against
	# libpthread, but does not do so ...
	# <azarah@gentoo.org> (23 Feb 2003)
	epatch ${FILESDIR}/${P}-fix-dep-link.patch

	# We should get dump185 to link against system db1 ..
	# <azarah@gentoo.org> (23 Feb 2003)
	mv ${S}/dist/Makefile.in ${S}/dist/Makefile.in.orig
	sed -e 's:DB185INC=:DB185INC= -I/usr/include/db1:' \
		-e 's:DB185LIB=:DB185LIB= -ldb1:' \
		${S}/dist/Makefile.in.orig > ${S}/dist/Makefile.in || die "Failed to sed"

	# Fix invalid .la files
	cd ${WORKDIR}/${P}/dist
	rm -f ltversion.sh
	# remove config.guess else we have problems with gcc-3.2
	rm -f config.guess
	sed -i "s,\(-D_GNU_SOURCE\),\1 ${CFLAGS}," configure

	cd ${S}
	epatch ${FILESDIR}/${P}-jarlocation.patch
	epatch ${FILESDIR}/db-3.2.9-java15.patch
	gnuconfig_update
}

src_compile() {
	local conf=
	local conf_shared=
	local conf_static=

	conf="${conf}
		--host=${CHOST} \
		--build=${CHOST} \
		--enable-cxx \
		--enable-compat185 \
		--enable-dump185 \
		--prefix=/usr"

	# --enable-rpc DOES NOT BUILD
	# Robin H. Johnson <robbat2@gentoo.org> (18 Oct 2003)

	conf_shared="${conf_shared}
		`use_enable java`
		--enable-dynamic"

	# TCL support is also broken
	# Robin H. Johnson <robbat2@gentoo.org> (18 Oct 2003)
	# conf_shared="${conf_shared}
	#	`use_enable tcl tcl`
	#	`use_with tcl tcl /usr/$(get_libdir)`"

	# NOTE: we should not build both shared and static versions
	#       of the libraries in the same build root!

	einfo "Configuring ${P} (static)..."
	mkdir -p ${S}/build-static
	cd ${S}/build-static
	strip=/bin/true \
	../dist/configure ${conf} ${conf_static} \
		--libdir=/usr/$(get_libdir) \
		--enable-static || die

	einfo "Configuring ${P} (shared)..."
	mkdir -p ${S}/build-shared
	cd ${S}/build-shared
	strip=/bin/true \
	../dist/configure ${conf} ${conf_shared} \
		--libdir=/usr/$(get_libdir) \
		--enable-shared || die

	# Parallel make does not work
	MAKEOPTS="${MAKEOPTS} -j1"
	einfo "Building ${P} (static)..."
	cd ${S}/build-static
	emake strip=/bin/true || die "Static build failed"
	einfo "Building ${P} (shared)..."
	cd ${S}/build-shared
	emake strip=/bin/true || die "Shared build failed"
}

src_install () {
	cd ${S}/build-shared
	make libdb=libdb-3.2.a \
		libcxx=libcxx_3.2.a \
		prefix=${D}/usr \
		libdir=${D}/usr/$(get_libdir) \
		strip=/bin/true \
		install || die

	cd ${S}/build-static
	newlib.a libdb.a libdb-3.2.a || die "failed to package static libraries!"
	newlib.a libdb_cxx.a libdb_cxx-3.2.a || die "failed to package static libraries!"

	db_src_install_headerslot || die "db_src_install_headerslot failed!"

	# this is now done in the db eclass, function db_fix_so and db_src_install_usrlibcleanup
	#cd ${D}/usr/lib
	#ln -s libdb-3.2.so libdb.so.3

	# For some reason, db.so's are *not* readable by group or others,
	# resulting in no one but root being able to use them!!!
	# This fixes it -- DR 15 Jun 2001
	cd ${D}/usr/$(get_libdir)
	chmod go+rx *.so
	# The .la's aren't readable either
	chmod go+r *.la

	cd ${S}
	dodoc README LICENSE

	db_src_install_doc || die "db_src_install_doc failed!"

	db_src_install_usrbinslot || die "db_src_install_usrbinslot failed!"

	db_src_install_usrlibcleanup || die "db_src_install_usrlibcleanup failed!"
}

pkg_postinst () {
	db_fix_so
}

pkg_postrm () {
	db_fix_so
}

src_test() {
	if has test $FEATURES; then
		eerror "We'd love to be able to test, but the testsuite is broken in the 3.2.9 series"
	fi
}
