# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/ati-drivers-extra/ati-drivers-extra-8.33.6.ebuild,v 1.3 2007/02/22 22:03:54 marienz Exp $

IUSE="qt3"

inherit eutils rpm

DESCRIPTION="Ati precompiled drivers extra application"
HOMEPAGE="http://www.ati.com"
ATI_URL="https://a248.e.akamai.net/f/674/9206/0/www2.ati.com/drivers/linux/"
SRC_URI="${ATI_URL}/ati-driver-installer-${PV}-x86.x86_64.run"

LICENSE="ATI GPL-2 QPL-1.0"
KEYWORDS="~amd64 ~x86"

DEPEND="=x11-drivers/ati-drivers-${PV}*
	!>=x11-drivers/ati-drivers-8.33.6-r2
	qt3? ( =x11-libs/qt-3* )"

ATIBIN="${D}/opt/ati/bin"
SLOT="0"

src_unpack() {
	local OLDBIN="/usr/X11R6/bin"

	cd ${WORKDIR}

	ebegin "Unpacking Ati drivers"
	sh ${DISTDIR}/${A} --extract ${WORKDIR} &> /dev/null
	eend $? || die "unpack failed"

	mkdir -p ${WORKDIR}/extra
	einfo "Unpacking fglrx_sample_source.tgz..."
	tar --no-same-owner -C ${WORKDIR}/extra/ -zxf \
		${WORKDIR}/common/usr/src/ati/fglrx_sample_source.tgz \
		|| die "Failed to unpack fglrx_sample_source.tgz!"
	# Defining USE_GLU allows this to compile with NVIDIA headers just fine
	sed -e \
		"s:-I/usr/X11R6/include:-D USE_GLU -I/usr/include:" \
		-i ${WORKDIR}/extra/fgl_glxgears/Makefile.Linux || die

	mkdir -p ${WORKDIR}/extra/fglrx_panel
	einfo "Unpacking fglrx_panel_sources.tgz..."
	tar --no-same-owner -C ${WORKDIR}/extra/fglrx_panel/ -zxf \
		${WORKDIR}/common/usr/src/ati/fglrx_panel_sources.tgz \
		|| die "Failed to unpack fglrx_panel_sources.tgz!"
	cd ${WORKDIR}/extra/fglrx_panel
#	epatch "${DISTDIR}/ati-drivers-extra-8.22.5-improvements.patch.bz2"
	sed -e "s:"${OLDBIN}":"${ATIBIN}":"\
		-i ${WORKDIR}/extra/fglrx_panel/Makefile
	#workaround
	cp ${FILESDIR}/fglrx_pp_proto.h ${WORKDIR}/extra/fglrx_panel
	}

src_compile() {
	einfo "Building fgl_glxgears"
	cd ${WORKDIR}/extra/fgl_glxgears
	make -f Makefile.Linux || ewarn "fgl_glxgears not build!"

	if use qt3
	then
		einfo "Building the QT fglx panel..."
		cd ${WORKDIR}/extra/fglrx_panel
		emake || die
	fi
}

src_install() {
	local ATI_ROOT="/usr/lib/opengl/ati"

	# Apps
	exeinto /opt/ati/bin
	doexe ${WORKDIR}/extra/fgl_glxgears/fgl_glxgears

	if use qt3
	then
		doexe ${WORKDIR}/extra/fglrx_panel/fireglcontrol

		insinto /usr/share/applications/
		doins ${FILESDIR}/fireglcontrol.desktop

		insinto /usr/share/pixmaps/
		doins ${WORKDIR}/extra/fglrx_panel/ati.xpm
	fi
}
