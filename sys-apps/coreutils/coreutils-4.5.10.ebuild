# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/coreutils/coreutils-4.5.10.ebuild,v 1.1 2003/03/15 03:28:31 seemant Exp $

inherit eutils

IUSE="nls build"

S="${WORKDIR}/${P}"
DESCRIPTION="Standard GNU file utilities (chmod, cp, dd, dir, ls...), text utilities (sort, tr, head, wc..), and shell utilities (whoami, who,...)"
HOMEPAGE="http://www.gnu.org/software/coreutils/"
SRC_URI="ftp://alpha.gnu.org/gnu/coreutils/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa arm"

DEPEND="virtual/glibc
	nls? ( sys-devel/gettext )"


src_unpack() {
	unpack ${A}
	cd ${S}

	# patch to remove Stallman's su/wheel group rant (which doesn't apply,
	# since Gentoo's su is not GNU/su, but that from shadow.
	epatch ${FILESDIR}/${P}-gentoo-rms.diff

	# Patch to add processor specific info to the uname output
	if [ -z "`use hppa`" ] && [ -z "`use arm`" ]
	then
		epatch ${FILESDIR}/${P}-gentoo-uname.diff
	fi
}

src_compile() {
	local myconf=""
	use nls || myconf="--disable-nls"
	
	econf \
		--bindir=/bin \
		${myconf} || die
	
	if [ "`use static`" ]
	then
		emake LDFLAGS=-static || die
	else
		emake || die
	fi
}

src_install() {
	einstall \
		bindir=${D}/bin || die

	# hostname comes from net-base
	# hostname does not work with the -f switch, which breaks gnome2
	#   amongst other things
	rm -f ${D}/{bin,usr/bin}/hostname ${D}/usr/share/man/man1/hostname.*

	# /bin/su comes from sys-apps/shadow
	rm -f ${D}/{bin,usr/bin}/su ${D}/usr/share/man/man1/su.*

	# /usr/bin/uptime comes from the sys-apps/procps packaga
	rm -f ${D}/{bin,usr/bin}/uptime ${D}/usr/share/man/man1/uptime*

	cd ${D}
	dodir /usr/bin
	rm -rf usr/lib
	cd usr/bin
	ln -s ../../bin/* .
	
	if [ -z "`use build`" ]
	then
		cd ${S}
		dodoc AUTHORS ChangeLog* COPYING NEWS README* THANKS TODO
	else
		rm -rf ${D}/usr/share
	fi
}

pkg_postinst() {
	# hostname does not get removed as it is included with older stage1
	# tarballs, and net-tools installs to /bin
	if [ -e ${ROOT}/usr/bin/hostname ] && [ ! -L ${ROOT}/usr/bin/hostname ]
	then
		rm -f ${ROOT}/usr/bin/hostname
	fi
}
