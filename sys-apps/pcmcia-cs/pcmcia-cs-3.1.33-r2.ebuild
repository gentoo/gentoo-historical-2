# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: System Team <system@gentoo.org>
# Author: Craig Joly <joly@ee.ualberta.ca>, Daniel Robbins <drobbins@gentoo.org>, Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/pcmcia-cs/pcmcia-cs-3.1.33-r2.ebuild,v 1.1 2002/03/19 17:23:31 chadh Exp $

# This ebuild installs ${FILESDIR}/hermes.conf, which you can get from
# http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/hermes.conf

S=${WORKDIR}/${P}
DESCRIPTION="PCMCIA tools for Linux"
SRC_URI="http://prdownloads.sourceforge.net/pcmcia-cs/${P}.tar.gz"
HOMEPAGE="http://pcmcia-cs.sourceforge.net"
DEPEND="sys-kernel/linux-headers X? ( virtual/x11 x11-libs/xforms )"
RDEPEND="X? ( virtual/x11 x11-libs/xforms )"

# Note: To use this ebuild, you should have the usr/src/linux symlink to 
# the kernel directory that pcmcia-cs should use for configuration.

src_unpack() {
	unpack ${A}
	cd ${S}
	cp Configure Configure.orig
	sed -e 's:usr/man:usr/share/man:g' Configure.orig > Configure
	#man pages will now install into /usr/share/man
}

src_compile() {
	local myconf
	if [ -z "`use trusted`" ] ; then
		myconf="--trust"
	else
		myconf="--notrust"
	fi

	if [ -z "`use apm`" ] ; then
		myconf="$myconf --apm"
	else
		myconf="$myconf --noapm"
	fi

	if [ -z "`use pnp`" ] ; then
		myconf="$myconf --pnp"
	else
		myconf="$myconf --nopnp"
	fi
	
	if [ -z "`use nocardbus`" ] ; then
		myconf="$myconf --cardbus"
	else
		myconf="$myconf --nocardbus"
	fi

	#use $CFLAGS for user tools, but standard kernel optimizations for the kernel modules (for compatibility)
	./Configure -n \
		--target=${D} \
		--srctree \
		--kernel=/usr/src/linux \
		--arch="i386" \
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
	emake all || die "failed compiling"
}

src_install () {
	make PREFIX=${D} install || die "failed installing"
	cd ${D}
	rm -rf etc/rc*.d
	# remove X util if USE X isn't set
	# this is simply much easier than patching configure or the makefiles
	# not to build them in the first place
	use X || rm -rf usr/X11R6
	# todo: if they are nstalled, move them to /usr
		
	insinto /etc/conf.d
	newins ${FILESDIR}/pcmcia.conf pcmcia

	insinto /etc/pcmcia
	doins ${FILESDIR}/network

	# install our own init script
	exeinto /etc/init.d
	newexe ${FILESDIR}/pcmcia.rc6 pcmcia
	if [ -z "`use build`" ]
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
}

src_postinst() {
	einfo "To avail yourself of the pcmcia-cs drivers, you have to disable the PCMCIA support in the kernel."
	einfo "(Otherwise, you might experience CardServices version mismatch errors)"
}
