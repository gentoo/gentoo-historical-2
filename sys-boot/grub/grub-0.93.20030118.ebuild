# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-boot/grub/grub-0.93.20030118.ebuild,v 1.9 2005/01/20 18:37:45 eradicator Exp $

inherit mount-boot eutils flag-o-matic

NEWP=${PN}-${PV%.*}
DESCRIPTION="GNU GRUB boot loader"
HOMEPAGE="http://www.gnu.org/software/grub/"
SRC_URI="ftp://alpha.gnu.org/gnu/grub/${NEWP}.tar.gz
	mirror://gentoo/${P}-gentoo.diff.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* x86"
IUSE="static"

RDEPEND=">=sys-libs/ncurses-5.2-r5"
DEPEND="$RDEPEND
	>=sys-devel/autoconf-2.58"
PROVIDE="virtual/bootloader"

S=${WORKDIR}/${NEWP}

src_unpack() {
	unpack ${A} || die
	cd ${S} || die
	# grub-0.93.20030118-gentoo.diff; <woodchip@gentoo.org> (18 Jan 2003)
	# -fixes from grub CVS pulled on 20030118
	# -vga16 patches; mined from Debian's grub-0.93+cvs20030102-1.diff
	# -special-raid-devices.patch
	# -addsyncs.patch
	# -splashimagehelp.patch
	# -configfile.patch
	# -installcopyonly.patch
	epatch ${WORKDIR}/${P}-gentoo.diff

	# grub-0.93-gcc3.3.diff <johnm@gentoo.org> (14 Sep 2003)
	# -fixes compile error with >=gcc-3.3
	epatch ${FILESDIR}/grub-0.93-gcc3.3.diff

	WANT_AUTOCONF=2.5 autoconf || die
}

src_compile() {
	filter-flags -fstack-protector
	filter-flags -fPIC

	### i686-specific code in the boot loader is a bad idea; disabling to ensure
	### at least some compatibility if the hard drive is moved to an older or
	### incompatible system.
	unset CFLAGS

	use static && export LDFLAGS="${LDFLAGS} -static"

	# hardened automatic PIC plus PIE building should be suppressed
	# because of assembler instructions that cannot be compiled PIC
	HARDENED_CFLAGS="`test_flag -fno-pic` `test_flag -nopie` `test_flag -fno-stack-protector`"

	econf CC="${CC:=gcc} ${HARDENED_CFLAGS}" --exec-prefix=/ \
		--disable-auto-linux-mem-opt || die

	emake CC="${CC:=gcc} ${HARDENED_CFLAGS}" || die
}

src_install() {
	einstall exec_prefix=${D}/ || die

	insinto /boot/grub
	doins ${FILESDIR}/splash.xpm.gz
	newins docs/menu.lst grub.conf.sample

	dodoc AUTHORS BUGS COPYING ChangeLog NEWS README THANKS TODO
	newdoc docs/menu.lst grub.conf.sample
}

pkg_postinst() {
	[ "$ROOT" != "/" ] && return 0
	/sbin/grub-install --just-copy

	# change menu.lst to grub.conf
	if [ ! -e /boot/grub/grub.conf -a -e /boot/grub/menu.lst ]
	then
		mv /boot/grub/menu.lst /boot/grub/grub.conf
		ln -s grub.conf /boot/grub/menu.lst
		ewarn
		ewarn "*** IMPORTANT NOTE: menu.lst has been renamed to grub.conf"
		ewarn
	fi
}
