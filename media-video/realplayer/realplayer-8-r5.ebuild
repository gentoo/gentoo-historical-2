# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/realplayer/realplayer-8-r5.ebuild,v 1.5 2003/03/16 14:27:37 liquidx Exp $

inherit nsplugins kde

IUSE="kde gnome"

DESCRIPTION="RealPlayer 8 is a streaming media player"
HOMEPAGE="http://forms.real.com/real/player/unix/unix.html"

# !! READ THIS !! 
# Due to fetch restrictions, you need to go to the above URL and fill out the
# form in order to be able to download the binary. When done, you should copy
# or move the binary into /usr/portage/distfiles. No need to chmod +x

if use x86
then
	A="rp8_linux20_libc6_i386_cs2.bin"
elif use ppc
then
	A="rp8_linux_powerpc_cs1.bin"
elif use sparc
then
	A="rp8_linux_sparc_cs1.bin"
elif use alpha
then
	A="rp8_linux_alpha_rh62_cs1.bin"
fi


SRC_URI="x86? http://docs.real.com/docs/playerpatch/unix/rv9_libc6_i386_cs2.tgz"

LICENSE="realplayer8"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha"

DEPEND="virtual/glibc"
RDEPEND="virtual/x11"
RESTRICT="nostrip"

BASE="/opt/RealPlayer8"
S=${WORKDIR}

pkg_setup() {
	if [ ! -f ${DISTDIR}/${A} ] ; then
		eerror "Please go to:"
		eerror "http://forms.real.com/real/player/unix/unix.html"
		eerror "And download the appropriate realplayer binary installer"
		eerror "for this architecture: ${ARCH}"
		use x86 && \
		eerror "Please note, do NOT download the rpm.  Just the .bin file"
		eerror "Named Linux 2.x (libc6 i386)"
		eerror ""
		eerror "Download ${A} and place it in ${DISTDIR}"
		eerror "Then emerge this package again"

		exit 1
	fi
}

src_unpack() {
	if use x86 ; then 
		BYTECOUNT=4799691
		RP8_BIN=`echo ${A} | awk '{ print $1 }'`
		RV9_X86=`echo ${A} | awk '{ print $2 }'`
	else
		RP8_BIN=${A}
		if use ppc ; then BYTECOUNT=7260910
		elif use alpha ; then BYTECOUNT=7130860
		elif use sparc ; then BYTECOUNT=6375000
		fi
	fi
	tail -c ${BYTECOUNT} ${DISTDIR}/${RP8_BIN} | tar xz 2> /dev/null
	if use x86 ; then 
		unpack ${RV9_X86}
	fi
}

src_compile() {
	einfo "Nothing to Compile, this is a binary package"
}

src_install () {
	insinto ${BASE}/Codecs
	doins Codecs/*
	if [ -d rv9/codecs ] ; then
		doins rv9/codecs/drv4.so.6.0 rv9/codecs/rv40.so.6.0
	fi
	insinto ${BASE}/Common
	doins Common/*
	insinto ${BASE}/Plugins/ExtResources
	doins Plugins/ExtResources/*
	insinto ${BASE}/Plugins
	doins Plugins/*.so.6.0 
	insinto ${BASE}
	doins *.xpm *.png *.rm rpnp.so LICENSE README ${FILESDIR}/mimeinfo
	exeinto ${BASE}
	doexe realplay
	dodir /opt/bin
	dosym ${BASE}/realplay /opt/bin

	# NS plugin
	for b in /opt/netscape /usr/lib/mozilla /usr/lib/nsbrowser 
	do
		if [ -d ${b} ] ; then
			dodir ${b}/plugins
			dosym ${BASE}/rpnp.so ${b}/plugins
		fi
	done

	# Desktop menu entry ; KDE, Gnome
	if use kde ; then
		insinto ${KDEDIR}/share/applnk/Multimedia
		doins ${FILESDIR}/realplayer.desktop
	fi
	if use gnome ; then
		insinto /usr/share/applications
		doins ${FILESDIR}/realplayer.desktop
	fi

	cp rp7.xpm realplayer8.xpm
	insinto /usr/share/pixmaps
	doins realplayer8.xpm

	# Mimetypes - Intentionally left blank (for now)
	# Better not use the provided scripts from Real, they are outdated 
	# See ${BASE}/mimeinfo for the correct mimetypes if you need them
}

pkg_postinst() {
	echo
	einfo "Finished installing RealPlayer8 into ${BASE}"
	einfo "You can start the player by running 'realplay'"
	einfo "You should agree to the terms in ${BASE}/LICENSE or unmerge"
	echo
}
