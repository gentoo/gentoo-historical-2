# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/wget/wget-1.8.2.ebuild,v 1.11 2002/12/20 16:45:06 aliz Exp $

IUSE="ssl nls static"

NPVER=20011209
S=${WORKDIR}/${P}
DESCRIPTION="Network utility to retrieve files from the WWW"
SRC_URI="mirror://gnu/wget/${P}.tar.gz
         http://www.biscom.net/~cade/away/wget-new-percentage/wget-new-percentage-cvs-${NPVER}.tar.gz"
HOMEPAGE="http://wget.sunsite.dk"
RDEPEND="virtual/glibc ssl? ( >=dev-libs/openssl-0.9.6b )"
DEPEND="$RDEPEND nls? ( sys-devel/gettext )"
KEYWORDS="x86 ppc sparc alpha"
LICENSE="GPL-2"
SLOT="0"

src_unpack() {
	unpack ${P}.tar.gz
	unpack wget-new-percentage-cvs-${NPVER}.tar.gz
	cd ${S}/src
	patch -p0 < ${WORKDIR}/wget-new-percentage/wnp-20011208-2.diff || die
}

src_compile() {
	local myconf
	use nls || myconf="--disable-nls"
	use ssl && myconf="${myconf} --with-ssl"
	use ssl || myconf="${myconf} --without-ssl --disable-opie --disable-digest"
	[ -z "$DEBUG" ] && myconf="${myconf} --disable-debug"
	use ssl && CFLAGS="${CFLAGS} -I/usr/include/openssl"
	./configure --prefix=/usr --sysconfdir=/etc/wget \
		--infodir=/usr/share/info --mandir=usr/share/man $myconf || die
	if use static; then
		make LDFLAGS="--static" || die
	else
		make || die
	fi
}

src_install() {   
	if use build; then
		insinto /usr
		dobin ${S}/src/wget	
		return
	fi                      
	make prefix=${D}/usr sysconfdir=${D}/etc/wget \
		mandir=${D}/usr/share/man infodir=${D}/usr/share/info install || die
	dodoc AUTHORS COPYING ChangeLog MACHINES MAILING-LIST NEWS README TODO 
	dodoc doc/sample.wgetrc
}
