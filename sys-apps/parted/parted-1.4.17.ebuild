# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Peter Gavin <pete@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/parted/parted-1.4.17.ebuild,v 1.2 2001/08/05 22:58:06 pete Exp $

#P=
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="an advanced partition modification system"
SRC_URI="ftp://ftp.gnu.org/gnu/${PN}/${A}"
HOMEPAGE="http://www.gnu.org/software/${PN}"

RDEPEND="virtual/glibc
	>=sys-apps/e2fsprogs-1.19-r2
	readline? ( >=sys-libs/readline-4.1-r2 )
	nls? ( sys-devel/gettext-0.10.38 )
	python? ( >=dev-lang/python-2.0 )"

DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.50
	>=sys-devel/automake-1.4_p5"

src_unpack() {
    unpack ${A}
    cd ${S}
	
	# gettext was totally hosed in this package, so I had to redo it.
	# I also added the python module
    try patch -p1 < ${FILESDIR}/${PF}-gentoo.diff
	echo ">>> Running aclocal..."
    try aclocal
	echo ">>> Running autoconf..."
    try autoconf
	echo ">>> Running automake..."
    try automake
	echo ">>> Running autoheader..."
	try autoheader
}

src_compile() {
    if [ "`use readline`" ]
    then
		myconf="${myconf} --with-readline"
    fi
    if [ "`use python`" ]
    then
		myconf="${myconf} --with-python"
    fi
	if [ -z "`use nls`" ]
	then
		myconf="${myconf} --disable-nls"
	else
		myconf="${myconf}"
	fi
    try ./configure --prefix=/usr --target=${CHOST} ${myconf}
	cd ${S}
    try make
}

src_install () {
    try make DESTDIR=${D} install
	if [ -z "`use bootcd`" ]
	then
		dodoc ABOUT-NLS AUTHORS BUGS COPYING ChangeLog NEWS README THANKS TODO
		cd doc ; docinto doc
		dodoc API COPYING.DOC FAT USER USER.jp
	else
		rm -rf ${D}/usr/share ${D}/usr/include ${D}/usr/lib/lib*.{a,la}
	fi
}
