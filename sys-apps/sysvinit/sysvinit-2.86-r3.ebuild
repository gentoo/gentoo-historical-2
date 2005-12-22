# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/sysvinit/sysvinit-2.86-r3.ebuild,v 1.3 2005/12/22 02:03:23 vapier Exp $

inherit eutils toolchain-funcs flag-o-matic

DESCRIPTION="/sbin/init - parent of all processes"
HOMEPAGE="http://freshmeat.net/projects/sysvinit/"
SRC_URI="ftp://ftp.cistron.nl/pub/people/miquels/software/${P}.tar.gz
	ftp://sunsite.unc.edu/pub/Linux/system/daemons/init/${P}.tar.gz
	http://www.gc-linux.org/down/isobel/kexec/sysvinit/sysvinit-2.86-kexec.patch"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="selinux bootstrap build ibm static"

RDEPEND="selinux? ( >=sys-libs/libselinux-1.18 sys-libs/libsepol )"
DEPEND="${RDEPEND}
	virtual/os-headers"

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"
	epatch "${FILESDIR}"/${P}-docs.patch
	epatch "${FILESDIR}"/${P}-shutdown-usage.patch
	epatch "${FILESDIR}"/sysvinit-2.86-off-by-one.patch
	epatch "${DISTDIR}"/sysvinit-2.86-kexec.patch
	epatch "${FILESDIR}"/sysvinit-2.86-POSIX-1003.1e.patch #5818
	epatch "${FILESDIR}"/sysvinit-2.86-execl.patch
	epatch "${FILESDIR}"/sysvinit-2.86-utmp-64bit.patch
	cd src
	epatch "${FILESDIR}"/${PV}-gentoo.patch
	use selinux && epatch "${FILESDIR}"/${PV}-selinux.patch

	# Mung inittab for specific architectures
	cd "${WORKDIR}"
	cp "${FILESDIR}"/inittab . || die "cp inittab"
	local insert=""
	if use ibm ; then
		insert="#hvc0:2345:respawn:/sbin/agetty -L 9600 hvc0"$'\n'
		insert="${insert}#hvsi:2345:respawn:/sbin/agetty -L 19200 hvsi0"
	fi
	use arm && insert='#f0:12345:respawn:/sbin/agetty 9600 ttyFB0 vt100'
	use hppa && insert='b0:12345:respawn:/sbin/agetty 9600 ttyB0 vt100'
	(use arm || use mips || use sh || use sparc) && sed -i '/ttyS0/s:#::' inittab
	[[ -n ${insert} ]] && echo "# Architecture specific features"$'\n'"${insert}" >> inittab
}

src_compile() {
	use static && append-ldflags -static

	# Note: The LCRYPT define below overrides the test in
	# sysvinit's Makefile.  This is because sulogin must be linked
	# to libcrypt in any case, but when building stage2 in
	# catalyst, /usr/lib/libcrypt.a isn't available.  In truth
	# this doesn't change how sulogin is built since ld would use
	# the shared obj by default anyway!  The other option is to
	# refrain from building sulogin, but that isn't a good option.
	# (09 Jul 2004 agriffis)
	emake -C src \
		CC="$(tc-getCC)" \
		DISTRO="Gentoo" \
		LCRYPT="-lcrypt" \
		|| die
}

src_install() {
	dodoc README doc/*

	cd src
	make install DISTRO="Gentoo" ROOT="${D}" || die "make install"

	insinto /etc
	doins "${WORKDIR}"/inittab || die "inittab"
}

pkg_postinst() {
	# Reload init to fix unmounting problems of / on next reboot.
	# This is really needed, as without the new version of init cause init
	# not to quit properly on reboot, and causes a fsck of / on next reboot.
	if [[ ${ROOT} == / ]] && ! use build && ! use bootstrap; then
		# Do not return an error if this fails
		/sbin/telinit U &>/dev/null
	fi
}
