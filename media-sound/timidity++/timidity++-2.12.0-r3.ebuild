# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/timidity++/timidity++-2.12.0-r3.ebuild,v 1.12 2004/04/16 05:37:26 vapier Exp $

inherit gnuconfig

MY_P=TiMidity++-${PV}-pre1
S=${WORKDIR}/${MY_P}
DESCRIPTION="A handy MIDI to WAV converter with OSS and ALSA output support"
HOMEPAGE="http://www.goice.co.jp/member/mo/timidity/"
SRC_URI="http://www.goice.co.jp/member/mo/timidity/dist/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc ~amd64 ~sparc"
IUSE="oss nas esd motif X gtk oggvorbis tcltk slang alsa"

RDEPEND=">=sys-libs/ncurses-5.0
	X? ( virtual/x11 )
	esd? ( >=media-sound/esound-0.2.22 )
	gtk? ( =x11-libs/gtk+-1.2* )
	nas? ( >=media-libs/nas-1.4 )
	alsa? ( media-libs/alsa-lib )
	motif? ( >=x11-libs/openmotif-2.1 )
	slang? ( >=sys-libs/slang-1.4 )
	tcltk? ( >=dev-lang/tk-8.1 )
	oggvorbis? ( >=media-libs/libvorbis-1.0_beta4 )"
DEPEND="${RDEPEND}
	sys-devel/autoconf"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-alsalib-fix.patch
}

src_compile() {
	local myconf
	local audios
	local interfaces

	if use amd64 ; then
		epatch ${FILESDIR}/gnuconfig_update.patch
		epatch ${FILESDIR}/long-64bit.patch
		gnuconfig_update
	fi

	interfaces="dynamic,ncurses,emacs,vt100"
	use oss && audios="oss";

	use X \
		&& myconf="${myconf} --with-x \
			--enable-spectrogram --enable-wrd" \
		&& interfaces="${interfaces},xskin,xaw" \
		|| myconf="${myconf} --without-x "

	use slang && interfaces="${interfaces},slang"
	if use X ; then \
		use gtk && interfaces="${interfaces},gtk";
		use motif && interfaces="${interfaces},motif";
	fi

	use alsa \
		&& audios="${audios},alsa" \
		&& interfaces="${interfaces},alsaseq" \
		&& myconf="${myconf} --with-default-output=alsa"

	use esd && audios="${audios},esd"
	use oggvorbis && audios="${audios},vorbis"
	use nas && audios="${audios},nas"

	econf \
		--localstatedir=/var/state/timidity++ \
		--with-elf \
		--enable-audio=${audios} \
		--enable-interface=${interfaces} \
		--enable-server \
		--enable-network \
		${myconf} || die

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodir /usr/share/timidity/config
	insinto /usr/share/timidity/config
	doins ${FILESDIR}/timidity.cfg
	dodoc AUTHORS ChangeLog* INSTALL*
	dodoc NEWS README*

	if use alsa; then
		insinto /etc/conf.d
		newins ${FILESDIR}/conf.d.timidity timidity

		exeinto /etc/init.d
		newexe ${FILESDIR}/init.d.timidity timidity
	fi
}

pkg_postinst() {
	einfo ""
	einfo "A timidity config file has been installed in"
	einfo "/usr/share/timitidy/config/timidity.cfg. This"
	einfo "file must to copied into /usr/share/timidity/"
	einfo "and edited to match your configuration."
	einfo ""
	if use alsa; then
		einfo "An init script for the alsa timidity sequencer has been installed."
		einfo "If you wish to use the timidity virtual sequencer, edit /etc/conf.d/timidity"
		einfo "and run 'rc-update add timidity <runlevel> && /etc/init.d/timidity start'"
	fi
}
