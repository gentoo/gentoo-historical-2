# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pcmcia-cs/pcmcia-cs-3.2.4.ebuild,v 1.12 2005/01/08 03:31:58 dragonheart Exp $

inherit eutils

OV="orinoco-0.13b"

DESCRIPTION="PCMCIA tools for Linux"
SRC_URI="mirror://sourceforge/pcmcia-cs/${P}.tar.gz
	http://airsnort.shmoo.com/${P}-orinoco-patch.diff"

HOMEPAGE="http://pcmcia-cs.sourceforge.net"
IUSE="trusted build apm pnp nocardbus"
DEPEND="virtual/os-headers"
RDEPEND=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64 -sparc"

# check arch for configure
if [ ${ARCH} = "x86" ] ; then
	MY_ARCH="i386"
else
	MY_ARCH="ppc"
fi

# Note: To use this ebuild, you should have the usr/src/linux symlink to
# the kernel directory that pcmcia-cs should use for configuration.

src_unpack() {
	check_KV
	okvminor="${KV#*.}" ; okvminor="${okvminor%%.*}"
	if [ "${okvminor}" -gt 4 ]; then
		eerror "This version of pcmcia-cs will NOT work with 2.6 kernels"
		eerror "Please use pcmcia-cs-3.2.5-r1 in combination with *kernel* PCMCIA"
		eerror "drivers to use PCMCIA on a 2.6 kernel."
		die "This version of pcmcia-cs does not support 2.6 kernels"
	fi

	unpack ${P}.tar.gz

	# pcmcia-cs now has the latest orinoco driver included

	cd ${S}
	epatch ${DISTDIR}/${P}-orinoco-patch.diff

	cd ${S}
	mv Configure Configure.orig
	sed -e 's:usr/man:usr/share/man:g' Configure.orig > Configure
	chmod ug+x Configure
	#man pages will now install into /usr/share/man


}

src_compile() {
	local myconf
	if use trusted ; then
		myconf="--trust"
	else
		myconf="--notrust"
	fi

	if use apm ; then
		myconf="$myconf --apm"
	else
		myconf="$myconf --noapm"
	fi

	if use pnp ; then
		myconf="$myconf --pnp"
	else
		myconf="$myconf --nopnp"
	fi

	if use nocardbus ; then
		myconf="$myconf --nocardbus"
	else
		myconf="$myconf --cardbus"
	fi

	#use $CFLAGS for user tools, but standard kernel optimizations for the kernel modules (for compatibility)
	./Configure -n \
		--target=${D} \
		--srctree \
		--kernel=/usr/src/linux \
		--arch="${MY_ARCH}" \
		--uflags="$CFLAGS" \
		--kflags="-Wall -Wstrict-prototypes -O2 -fomit-frame-pointer" \
		$myconf || die "failed configuring"
	# nopnp and noapm are important, because without them the pcmcia-cs
	# tools will require a kernel with ISA PnP and/or APM support,
	# which cannot be guaranteed.  We need to make sure the tools
	# work *all* the time, not just some of the time.

	# The --srctree option tells pcmcia-cs to configure for the kernel in /usr/src/linux
	# rather than the currently-running kernel.  It's Gentoo Linux policy to configure for
	# the kernel in /usr/src/linux

	sed -e "/^HAS_FORMS/d" config.out > config.out.sed
	sed -e "/^HAS_FORMS/d" config.mk > config.mk.sed
	sed -e "s/^FLIBS=\".*\"/FLIBS=\"\"/" config.out.sed > config.out
	sed -e "s/^FLIBS=\".*\"/FLIBS=\"\"/" config.mk.sed > config.mk
	rm -f config.out.sed
	rm -f config.mk.sed

	emake all || die "failed compiling"
}

src_install () {
	make PREFIX=${D} install || die "failed installing"
	cd ${D}
	rm -rf etc/rc*.d
	# remove X
	# this is simply much easier than patching configure or the makefiles
	# not to build them in the first place
	rm -rf usr/X11R6
	# todo: if they are nstalled, move them to /usr

	insinto /etc/conf.d
	newins ${FILESDIR}/pcmcia.conf pcmcia

	exeinto /etc/pcmcia
	doexe ${FILESDIR}/network

	# install our own init script
	exeinto /etc/init.d
	newexe ${FILESDIR}/pcmcia.rc pcmcia
	if ! use build
	then
		cd ${S}
		# install docs
		dodoc BUGS CHANGES COPYING LICENSE MAINTAINERS README \
			README-2.4 SUPPORTED.CARDS doc/*
	else
		rm -rf ${D}/usr/share/man
	fi
	rm -f ${D}/etc/modules.conf
	rm -rf ${D}/var/lib/pcmcia

	# if on ppc set the ppc revised config.opts
	if [ ${ARCH} = "ppc" ] ; then
		insinto /etc/pcmcia
		newins ${FILESDIR}/ppc.config.opts config.opts
	fi
}

pkg_postinst() {
	einfo "To avail yourself of the pcmcia-cs drivers, you have to disable the PCMCIA support in the kernel."
	einfo "(Otherwise, you might experience CardServices version mismatch errors)"
	einfo ""
	einfo "Proper kernel config for this package is that PCMCIA/CardBus under General Setup is off and"
	einfo "Wireless LAN (non-ham radio) is on but no modules or drivers turned on under Network Device Support"
	einfo "if you have wireless."
}
