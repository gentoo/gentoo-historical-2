# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/lirc/lirc-0.7.1.ebuild,v 1.4 2005/05/15 08:11:27 lanius Exp $

inherit eutils linux-mod flag-o-matic

DESCRIPTION="LIRC is a package that allows you to decode and send infra-red \
	signals of many (but not all) commonly used remote controls."
HOMEPAGE="http://www.lirc.org"

# LIRC_OPTS = ???? v
# This are the defaults. With this support for all supported remotes
# will be build.
# If you want other options then set the Environment variable to your needs.

# Note: If you don't specify the driver configure becomes interactiv.

# You have to know, which driver you want;
# --with-driver=X

# where X is one of:
# none, any, act200l, animax, atilibusb,
# atiusb, audio, avermedia, avermedia_vdomate,
# avermedia98, bestbuy, bestbuy2, breakoutbox,
# bte, caraca, chronos, comX,
# creative_infracd, dsp, cph03x, cph06x,
# creative, devinput, exaudio, flyvideo,
# gvbctv5pci, hauppauge, hauppauge_dvb,
# hercules_smarttv_stereo, igorplugusb, irdeo,
# irdeo_remote, irman, irreal, it87, knc_one,
# kworld, leadtek_0007, leadtek_0010,
# livedrive_midi, livedrive_seq, logitech,
# lptX, mceusb, mediafocusI, mp3anywhere,
# packard_bell, parallel, pcmak, pcmak_usb,
# pctv, pixelview_bt878, pixelview_pak,
# pixelview_pro, provideo, realmagic,
# remotemaster, sa1100, sasem, serial,
# silitek, sir, slinke, tekram, tekram_bt829,
# tira, tvbox, udp, uirt2, uirt2_raw"
# winfast_tv2000 is now leadtek_0010
# streamzap

# This could be usefull too

# --with-port=port	# port number for the lirc device.
# --with-irq=irq	# irq line for the lirc device.
# --with-timer=value	# timer value for the parallel driver
# --with-tty=file	# tty to use (Irman, RemoteMaster, etc.)
# --without-soft-carrier	# if your serial hw generates carrier
# --with-transmitter	# if you use a transmitter diode

SLOT="0"
LICENSE="GPL-2"
IUSE="debug doc X"
KEYWORDS="~x86 ~ppc ~alpha ~ia64 ~amd64 ~ppc64"

RDEPEND="virtual/libc
	X? ( virtual/x11 )"

DEPEND="virtual/linux-sources
	sys-devel/autoconf
	${RDEPEND}"

SRC_URI="mirror://sourceforge/lirc/${P}.tar.bz2"

src_unpack() {
	unpack ${A}
	cd ${S}
	#epatch ${FILESDIR}/lirc-0.7.0-xbox.patch.bz2

	filter-flags -Wl,-O1
	sed	-i -e "s:-O2 -g:${CFLAGS}:" configure configure.in

	# fix bz878 compilation, bug #87505
	sed -i -e "s:lircd.conf.pixelview_bt878:lircd.conf.playtv_bt878" configure configure.in
}

src_compile() {
	# set default configure options
	[ "x${LIRC_OPTS}" = x ] && [ "${PROFILE_ARCH}" == "xbox" ] && \
		LIRC_OPTS="--with-driver=xboxusb"
	[ "x${LIRC_OPTS}" = x ] && LIRC_OPTS="--with-driver=serial \
		--with-port=0x3f8 --with-irq=4"

	# remove parallel driver on SMP systems
	if linux_chkconfig_present SMP ; then
		sed -i -e "s:lirc_parallel::" drivers/Makefile
	fi

	# Patch bad configure for /usr/src/linux
	libtoolize --copy --force || die "libtoolize failed"
	sed -si "s|/usr/src/kernel\-source\-\`uname \-r\` /usr/src/linux\-\`uname \-r\` ||" \
		acinclude.m4 aclocal.m4 configure || die "/usr/src/linux sed failed"

	get_version
	sed -si "s|\`uname \-r\`|${KV_FULL}|" configure configure.in setup.sh || \
		die "/lib/modules sed failed"

	unset ARCH
	export WANT_AUTOCONF=2.5

	econf \
		--disable-manage-devices \
		--localstatedir=/var \
		--with-syslog=LOG_DAEMON \
		--enable-sandboxed \
		`use_enable debug` \
		`use_with X` \
		${LIRC_OPTS} || die "./configure failed"

	convert_to_m ${S}/Makefile
	emake || die

}

src_install() {
	make DESTDIR=${D} install || die

	exeinto /etc/init.d
	doexe ${FILESDIR}/lircd
	doexe ${FILESDIR}/lircmd

	insinto /etc/conf.d
	newins ${FILESDIR}/lircd.conf lircd

	if use doc ; then
		dohtml doc/html/*.html
		insinto /usr/share/doc/${PF}/images
		doins doc/images/*
	fi
}

pkg_preinst() {
	cp ${ROOT}/etc/lircd.conf ${IMAGE}/etc
}

pkg_postinst() {
	einfo
	einfo "The lirc Linux Infrared Remote Control Package has been"
	einfo "merged, please read the documentation, and if necessary"
	einfo "add what is needed to /etc/modules.autoload or"
	einfo "/etc/modules.d.  If you need special compile options"
	einfo "then read the comments at the begin of this"
	einfo "ebuild (source) and set the LIRC_OPTS environment"
	einfo "variable to your needs."
	einfo

	update_depmod
}
