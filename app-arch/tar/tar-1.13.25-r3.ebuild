# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/tar/tar-1.13.25-r3.ebuild,v 1.5 2004/01/04 16:54:34 seemant Exp $

inherit eutils gnuconfig

IUSE="nls static build"

S=${WORKDIR}/${P}
DESCRIPTION="Use this to try make tarballs :)"
HOMEPAGE="http://www.gnu.org/software/tar/"
SRC_URI="mirror://gentoo/${P}.tar.gz
	mirror://gnu/tar/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 alpha mips hppa arm ppc ia64 sparc ppc64"

DEPEND="app-arch/gzip
	app-arch/bzip2
	app-arch/ncompress"

RDEPEND="nls? ( >=sys-devel/gettext-0.10.35 )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PF}.gentoo.diff
}

src_compile() {

	# Fix configure scripts to support linux-mips targets
	gnuconfig_update

	local myconf
	[ -z "`use nls`" ] && myconf="--disable-nls"
	econf \
		--bindir=/bin \
		--libexecdir=/usr/lib/misc \
		${myconf} || die

	if [ -z "`use static`" ]
	then
		emake || die
	else
		emake LDFLAGS=-static || die
	fi

}

src_install() {
	make DESTDIR=${D} install || die
	#FHS 2.1 stuff
	dodir /usr/sbin
	cd ${D}
	mv usr/lib/misc/rmt usr/sbin/rmt.gnu
	dosym rmt.gnu /usr/sbin/rmt
	# a nasty yet required symlink:
	dodir /etc
	dosym /usr/sbin/rmt /etc/rmt
	cd ${S}
	if [ -z "`use build`" ]
	then
		dodoc AUTHORS ChangeLog* COPYING NEWS README* PORTS THANKS
		doman ${FILESDIR}/tar.1
	else
		rm -rf ${D}/usr/share
	fi
}
