# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pcmcia-cs/pcmcia-cs-3.2.5-r1.ebuild,v 1.6 2004/02/07 07:14:21 latexer Exp $

inherit eutils

S=${WORKDIR}/${P}
OV="orinoco-0.13e"

DESCRIPTION="PCMCIA tools for Linux"
SRC_URI="mirror://sourceforge/pcmcia-cs/${P}.tar.gz
		http://dev.gentoo.org/~latexer/files/patches/${P}-module-init-tools.diff.gz
		http://dev.gentoo.org/~latexer/files/patches/${P}-SMP-fix.diff.gz
		http://dev.gentoo.org/~latexer/files/${P}-orinoco-monitor.diff.gz
		ppc? ( http://dev.gentoo.org/~latexer/files/patches/${P}-ppc-fix.diff.gz )"

HOMEPAGE="http://pcmcia-cs.sourceforge.net"
IUSE="trusted build apm pnp nocardbus"
DEPEND="sys-kernel/linux-headers
		>=sys-apps/sed-4"
RDEPEND=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

# Note: To use this ebuild, you should have the usr/src/linux symlink to
# the kernel directory that pcmcia-cs should use for configuration.

src_unpack() {

	unpack ${P}.tar.gz || die "unpack failed"
	cd ${S} || die "cd ${S} failed"

	# parse out the middle number from the kernel version
	check_KV
	okvminor="${KV#*.}" ; okvminor="${okvminor%%.*}"
	[ -n "${okvminor}" ] || die "couldn't figure out okvminor"

	# 3.2.5 includes the latest orinoco (0.13e), so just patch to add
	# monitor mode
	epatch ${DISTDIR}/${P}-orinoco-monitor.diff.gz

	# Fix for module-init-tools only systems
	epatch ${DISTDIR}/${P}-module-init-tools.diff.gz

	# Fix for compiling with SMP (mainly for liveCDs, does your laptop have
	# multiple procs?)
	epatch ${DISTDIR}/${P}-SMP-fix.diff.gz

	# Fix for compilation against recent benh kernels
	[ "${ARCH}" == "ppc" ] && epatch ${DISTDIR}/${P}-ppc-fix.diff.gz

	# If we're on 2.5.x or 2.6.x, modversions.h has *moved*
	if [ "${okvminor}" -ge "5" ]; then
		sed -i -e "s:include/linux/modvers:include/config/modvers:" Configure \
			|| die "sed Configure failed (1)"
	fi

	# Install man-pages into /usr/share/man
	sed -i -e 's:usr/man:usr/share/man:g' Configure \
		|| die "sed Configure failed (2)"
}

src_compile() {
	local myconf myarch

	if use trusted; then
		myconf="${myconf} --trust"
	else
		myconf="${myconf} --notrust"
	fi

	# Note that when built with apm support, pcmcia-cs will require a
	# kernel with APM support
	if use apm; then
		myconf="${myconf} --apm"
	else
		myconf="${myconf} --noapm"
	fi

	# Note that when built with pnp support, pcmcia-cs will require a
	# kernel with ISA PnP support
	if use pnp; then
		myconf="${myconf} --pnp"
	else
		myconf="${myconf} --nopnp"
	fi

	if use nocardbus; then
		myconf="${myconf} --nocardbus"
	else
		myconf="${myconf} --cardbus"
	fi

	# x86 is not a valid arch for configure... use a case statement
	# here to make it easy for other arches to add their own
	# workarounds.
	case "${ARCH}" in
		x86) myarch="i386" ;;
		*)   myarch="${ARCH}" ;;
	esac

	# Use $CFLAGS for user tools, but standard kernel optimizations
	# for the kernel modules (for compatibility).
	#
	# The --srctree option tells pcmcia-cs to configure for the kernel
	# in /usr/src/linux rather than the currently-running kernel.
	# It's Gentoo Linux policy to configure for
	# the kernel in /usr/src/linux
	./Configure -n \
		--target=${D} \
		--srctree \
		--kernel=/usr/src/linux \
		--arch="${myarch}" \
		--uflags="$CFLAGS" \
		--kflags="-Wall -Wstrict-prototypes -O2 -fomit-frame-pointer" \
		$myconf || die "failed configuring"

	sed -i -e '/^HAS_FORMS/d ; s/^FLIBS=".*"/FLIBS=""/' config.out config.mk

	emake DO_ORINOCO=1 all || die "failed compiling"
}

src_install () {
	make PREFIX=${D} install || die "failed installing"

	# remove included rc scripts since we have our own
	rm -rf ${D}/etc/rc*.d

	# remove X
	# this is simply much easier than patching configure or the makefiles
	# not to build them in the first place
	rm -rf ${D}/usr/X11R6
	# todo: if they are installed, move them to /usr

	insinto /etc/conf.d
	newins ${FILESDIR}/pcmcia.conf pcmcia

	exeinto /etc/pcmcia
	doexe ${FILESDIR}/network

	# install our own init script
	exeinto /etc/init.d
	newexe ${FILESDIR}/pcmcia.rc pcmcia

	# documentation
	if use build; then
		rm -rf ${D}/usr/share/man
	else
		dodoc BUGS CHANGES COPYING LICENSE MAINTAINERS README \
			README-2.4 SUPPORTED.CARDS doc/*
	fi
	rm -f ${D}/etc/modules.conf
	rm -rf ${D}/var/lib/pcmcia

	# if on ppc set the ppc revised config.opts
	if [ "${ARCH}" = "ppc" ]; then
		insinto /etc/pcmcia
		newins ${FILESDIR}/ppc.config.opts config.opts
	fi
}

pkg_postinst() {
	if [ "${okvminor}" -lt "5" ]
	then
		depmod -a

		einfo "To avail yourself of the pcmcia-cs drivers, you have to disable the"
		einfo "PCMCIA support in the kernel.  (Otherwise, you might experience"
		einfo "CardServices version mismatch errors)"
		einfo ""
		einfo "Proper kernel config for this package is that PCMCIA/CardBus under"
		einfo "General Setup is off and Wireless LAN (non-ham radio) is on but"
		einfo "no modules or drivers turned on under Network Device Support"
		einfo "if you have wireless."
	else
		einfo "For 2.5/2.6 kernels, the PCMCIA support from the kernel should"
		einfo "be used. Enable PCMCIA and any further drivers you need there,"
		einfo "and then use this package to install the PCMCIA tools."
	fi
}
