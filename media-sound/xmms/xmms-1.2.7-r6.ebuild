# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-sound/xmms/xmms-1.2.7-r6.ebuild,v 1.1 2002/05/26 14:05:33 azarah Exp $

PLO_VER="$(echo ${PV} | sed -e "s:\.::g")"
S=${WORKDIR}/${P}
DESCRIPTION="X MultiMedia System"
SRC_URI="ftp://ftp.xmms.org/xmms/1.2.x/${P}.tar.gz"
# This if for the Plover patch
#	avi? ( http://www.openface.ca/~nephtes/plover-xmms${PLO_VER}.tar.gz )"
HOMEPAGE="http://www.xmms.org/"

RDEPEND="=x11-libs/gtk+-1.2*
	>=media-libs/libmikmod-3.1.9
	avi? ( >=media-video/avifile-0.7.4.20020426-r2 )
	esd? ( >=media-sound/esound-0.2.22 )
	xml? ( >=dev-libs/libxml-1.8.15 )
	gnome? ( >=gnome-base/gnome-core-1.4.0.4-r1 )
	opengl? ( virtual/opengl )
	oggvorbis? ( >=media-libs/libvorbis-1.0_beta4 )"
	

DEPEND="${RDEPEND}
	nls? ( dev-util/intltool )"

src_unpack() {
	unpack ${P}.tar.gz

	cd ${S}

	# For plugins such as avi4xmms, xmms needs to be linked to libavifile
	# and libstdcxx.
	use avi && patch -p1 <${FILESDIR}/${P}-enable-avifile-plugins.patch || die

# This is for the Plover patch
#	use avi	&& (\
#		tar -zxf ${DISTDIR}/plover-xmms${PLO_VER}.tar.gz || die
#		cp plover-xmms${PLO_VER}.diff plover-xmms${PLO_VER}.diff.orig || die
#		sed -e "s:avifile-config:avifile-config0.7:g" \
#			plover-xmms${PLO_VER}.diff.orig >plover-xmms${PLO_VER}.diff
#		patch -p1 <plover-xmms${PLO_VER}.diff || die
#	)
}

src_compile() {
	local myopts

	use gnome \
		&& myopts="${myopts} --with-gnome" \
		|| myopts="${myopts} --without-gnome"

	use 3dnow \
		&& myopts="${myopts} --enable-3dnow" \
		|| myopts="${myopts} --disable-3dnow"

	use esd \
		&& myopts="${myopts} --enable-esd" \
		|| myopts="${myopts} --disable-esd"

	use opengl \
		&& myopts="${myopts} --enable-opengl" \
		|| myopts="${myopts} --disable-opengl"
	
	use oggvorbis \
		&& myopts="${myopts} --with-ogg --with-vorbis" \
		|| myopts="${myopts} --disable-ogg-test --disable-vorbis-test"

	use xml \
		|| myopts="${myopts} --disable-cdindex"

	use nls \
		|| myopts="${myopts} --disable-nls"

	
	./configure --host=${CHOST} \
		--prefix=/usr \
		--mandir=/usr/share/man \
		${myopts} || die

	emake || die
}

src_install() {                               
	make prefix=${D}/usr \
	     mandir=${D}/usr/share/man \
	     sysconfdir=${D}/etc \
	     sysdir=${D}/usr/share/applets/Multimedia \
	     GNOME_SYSCONFDIR=${D}/etc \
	     install || die

	dodoc AUTHORS ChangeLog COPYING FAQ NEWS README TODO 
	
	mkdir -p ${D}/usr/share/xmms/Skins
	insinto /usr/share/pixmaps/
	donewins gnomexmms/gnomexmms.xpm xmms.xpm
	doins xmms/xmms_logo.xpm
	insinto /usr/share/pixmaps/mini
	doins xmms/xmms_mini.xpm

	insinto /etc/X11/wmconfig
	donewins xmms/xmms.wmconfig xmms

	if [ "`use gnome`" ]
	then
		insinto /usr/share/gnome/apps/Multimedia
		doins xmms/xmms.desktop
		dosed "s:xmms_mini.xpm:mini/xmms_mini.xpm:" \
			/usr/share/gnome/apps/Multimedia/xmms.desktop
	fi
}

