# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/rpm/rpm-4.2.1.ebuild,v 1.2 2003/10/21 18:53:42 cretin Exp $

inherit flag-o-matic libtool eutils

DESCRIPTION="Red Hat Package Management Utils"
SRC_URI="mirror://gentoo/rpm-4.2.1.tar.gz"
HOMEPAGE="http://www.rpm.org/"
SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
IUSE="nls python doc"
RDEPEND="=sys-libs/db-3.2*
	>=sys-libs/zlib-1.1.3
	>=sys-apps/bzip2-1.0.1
	>=dev-libs/popt-1.7
	>=app-crypt/gnupg-1.2
	dev-libs/elfutils
	dev-libs/beecrypt
	nls? ( sys-devel/gettext )
	python? ( =dev-lang/python-2.2* )
	doc? ( app-doc/doxygen )"
S=${WORKDIR}/rpm-4.2.1

strip-flags

src_unpack() {
	unpack ${A}
}

src_compile() {
	elibtoolize

	unset LD_ASSUME_KERNEL
	local myconf
	myconf="--enable-posixmutexes --without-javaglue"
	use python \
		&& myconf="${myconf} --with-python=2.2" \
		|| myconf="${myconf} --without-python"

	econf ${myconf} `use_enable nls` || die
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
	mv ${D}/bin/rpm ${D}/usr/bin
	rm -rf ${D}/bin
	# Fix for bug #8578 (app-arch/rpm create dead symlink)
	# Local RH 7.3 install has no such symlink anywhere
	# ------
	# UPDATE for 4.1!
	# There is a /usr/lib/rpm/rpmpopt-4.1 now
	# the symlink is still created incorrectly. ???
	rm -f ${D}/usr/lib/rpmpopt
	rm -f ${D}/usr/lib/libpopt*
	rm -f ${D}/usr/include/popt.h
	use nls && rm -f  ${D}/usr/share/locale/*/LC_MESSAGES/popt.mo
	rm -f ${D}/usr/share/man/man3/popt*

	keepdir /var/lib/rpm
	keepdir /usr/src/pc/{SRPMS,SPECS,SOURCES,RPMS,BUILD}
	keepdir /usr/src/pc/RPMS/{noarch,i{3,4,5,6}86,athlon}
	keepdir /usr/src/pc
	dodoc CHANGES COPYING CREDITS GROUPS README* RPM* TODO

	use nls || rm -rf ${D}/usr/share/man/{ko,ja,fr,pl,ru,sk}

	# create /usr/src/redhat/ and co for rpmbuild
	for d in /usr/src/redhat/{BUILD,RPMS,SOURCES,SPECS,SRPMS}; do
		dodir "${d}"
	done
}

pkg_postinst() {
	if [ -f ${ROOT}/var/lib/rpm/Packages ]; then
		einfo "RPM database found... Rebuilding database (may take a while)..."
		${ROOT}/usr/bin/rpm --rebuilddb --root=${ROOT}
	else
		einfo "No RPM database found... Creating database..."
		${ROOT}/usr/bin/rpm --initdb --root=${ROOT}
	fi
}
