# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>

A=${P}.tar.bz2
S=${WORKDIR}/${P}
DESCRIPTION="Groovy little ftp client"
SRC_URI="ftp://ftp.yars.free.net/pub/software/unix/net/ftp/client/lftp/${A}
	 http://metalab.unc.edu/pub/Linux/system/network/file-transfer/${A}"

HOMEPAGE="http://ftp.yars.free.net/projects/lftp/"

DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.1
	ssl? ( >=dev-libs/openssl-0.9.6 )
        nls? ( sys-devel/gettext )"

RDEPEND="virtual/glibc
	>=sys-libs/ncurses-5.1
	ssl? ( >=dev-libs/openssl-0.9.6 )"

src_compile() {
    local myconf
    if [ -z "`use nls`" ] ; then
      myconf="--disable-nls"
    fi
    if [ -z "`use ssl`" ] ; then
      myconf="$myconf --without-ssl"
    fi

    export CFLAGS="-fno-exceptions -fno-rtti ${CFLAGS}"
    export CXXFLAGS="-fno-exceptions -fno-rtti ${CXXFLAGS}"

    try ./configure --prefix=/usr --sysconfdir=/etc/lftp --with-modules --mandir=/usr/share/man $myconf
    try pmake
}

src_install() {

	try make prefix=${D}/usr sysconfdir=${D}/etc/lftp mandir=${D}/usr/share/man install

	dodoc BUGS COPYING ChangeLog FAQ FEATURES MIRRORS NEWS
	dodoc README* THANKS TODO
	
}





