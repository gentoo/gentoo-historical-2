# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# /space/gentoo/cvsroot/gentoo-x86/media-sound/xmms/xmms-1.2.7-r7.ebuild,v 1.2 2002/05/31 14:34:51 seemant Exp

IUSE="xml nls esd avi opengl oggvorbis 3dnow gnome"

inherit libtool

PLO_VER="$(echo ${PV} | sed -e "s:\.::g")"
S=${WORKDIR}/${P}
DESCRIPTION="X MultiMedia System"
XMMS_URI="ftp://ftp.xmms.org/xmms/1.2.x/${P}.tar.gz
	avi?( http://www.openface.ca/~nephtes/plover-${PN}${PLO_VER}.tar.gz )"
MMX_URI="http://members.jcom.home.ne.jp/jacobi/linux/etc/${P}-mmx.patch.gz"
use mmx || use 3dnow \
	&& SOURCE_HTTP="${XMMS_URI} ${MMX_URI}" \
	|| SOURCE_HTTP="${XMMS_URI}"
SRC_URI="${SOURCE_HTTP}"
HOMEPAGE="http://www.xmms.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"

RDEPEND="app-arch/unzip
	=x11-libs/gtk+-1.2*
	>=media-libs/libmikmod-3.1.9
	avi? ( >=media-video/avifile-0.7.4.20020426-r2 )
	esd? ( >=media-sound/esound-0.2.22 )
	xml? ( >=dev-libs/libxml-1.8.15 )
	gnome? ( >=gnome-base/gnome-panel-1.4.1 <gnome-base/gnome-panel-1.5.0 )
	opengl? ( virtual/opengl )
	oggvorbis? ( >=media-libs/libvorbis-1.0_beta4 )"

DEPEND="${RDEPEND}
	nls? ( dev-util/intltool )"

src_unpack() {
	unpack ${P}.tar.gz

	cd ${S}

	# For plugins such as avi4xmms, xmms needs to be linked to libavifile
	# and libstdcxx.
	#
	# NOTE: because we change a Makefile.am here, we run auto* at the
	#	  bottom.
	if use avi; then
		patch -p1 <${FILESDIR}/${P}-enable-avifile-plugins.patch || die
	fi
	
	# The following code prevents a correct unpack on PPC, so let's
	# exclude the code on that platform. Olivier Reisch <doctomoe@gentoo.org>
	if [ ${ARCH} != "ppc" ]
	then
		# For mmx/3dnow enabled CPUs, this patch adds mmx/3dnow optimisations
		#
		#
		# For you guys who favour this kind of USE flag checking ... this
		# is exactly why I do NOT like it, because the actual
		# "cat ${DISTDIR}/${P}-mmx.patch.gz | gunzip -c | patch -p1 || die"
		# was not in a subshell, it would ALWAYS fail to build if "mmx" or
		# "3dnow" was not in USE, because of the || die at the end.  So
		# PLEASE, PLEASE test things with all possible USE flags if you use
		# this style!!!!
		#
		# Azarah - 30 Jun 2002
		#
		if use mmx || use 3dnow
		then
			cat ${DISTDIR}/${P}-mmx.patch.gz | gunzip -c | patch -p1 || die
		fi
	fi

# This is for the Plover patch
#	use avi	&& (\
#		tar -zxf ${DISTDIR}/plover-xmms${PLO_VER}.tar.gz || die
#		cp plover-xmms${PLO_VER}.diff plover-xmms${PLO_VER}.diff.orig || die
#		sed -e "s:avifile-config:avifile-config0.7:g" \
#			plover-xmms${PLO_VER}.diff.orig >plover-xmms${PLO_VER}.diff
#		patch -p1 <plover-xmms${PLO_VER}.diff || die
#	)

	if [ ! -f ${S}/config.rpath ]; then
		touch ${S}/config.rpath
		chmod +x ${S}/config.rpath
	fi

	# We run automake and autoconf here else we get a lot of warning/errors.
	# I have tested this with gcc-2.95.3 and gcc-3.1.
	elibtoolize
	for x in ${S} ${S}/libxmms
	do
		cd ${x}
		aclocal
		export WANT_AUTOCONF_2_5=1
		automake --gnu --include-deps Makefile || die
		autoconf || die
	done
}

src_compile() {
	local myopts=""

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

	econf ${myopts}
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

	dodir /usr/share/xmms/Skins
	insinto /usr/share/pixmaps/
	donewins gnomexmms/gnomexmms.xpm xmms.xpm
	doins xmms/xmms_logo.xpm
	insinto /usr/share/pixmaps/mini
	doins xmms/xmms_mini.xpm

	insinto /etc/X11/wmconfig
	donewins xmms/xmms.wmconfig xmms

	if use gnome; then
		insinto /usr/share/gnome/apps/Multimedia
		doins xmms/xmms.desktop
		dosed "s:xmms_mini.xpm:mini/xmms_mini.xpm:" \
			/usr/share/gnome/apps/Multimedia/xmms.desktop
	else
		rm ${D}/usr/share/man/man1/gnomexmms*
	fi
}

pkg_postrm() {
	if [ -x ${ROOT}/usr/bin/xmms ] && [ ! -d ${ROOT}/usr/share/xmms/Skins ]
	then
		mkdir -p ${ROOT}/usr/share/xmms/Skins
	fi
}
