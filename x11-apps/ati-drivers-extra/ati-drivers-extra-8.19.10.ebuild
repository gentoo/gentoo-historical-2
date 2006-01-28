# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/ati-drivers-extra/ati-drivers-extra-8.19.10.ebuild,v 1.2 2006/01/28 14:51:19 lu_zero Exp $

IUSE="qt"

inherit eutils rpm linux-info linux-mod

DESCRIPTION="Ati precompiled drivers extra application"
HOMEPAGE="http://www.ati.com"
SRC_URI="x86? ( mirror://gentoo/ati-driver-installer-${PV}-i386.run )
	mirror://gentoo/ati-drivers-extra-8.19.10-improvements.patch.bz2
	 amd64? ( mirror://gentoo/ati-driver-installer-${PV}-x86_64.run )"

LICENSE="ATI GPL-2 QPL-1.0"
KEYWORDS="-amd64 ~x86"  # (~amd64 yet to be fixed)(see bug 95684)

DEPEND="=x11-drivers/ati-drivers-${PV}*
	qt? ( >=x11-libs/qt-3.0 )"

ATIBIN="${D}/opt/ati/bin"
RESTRICT="nostrip"

src_unpack() {
	local OLDBIN="/usr/X11R6/bin"

	cd ${WORKDIR}

	ebegin "Unpacking Ati drivers"
	sh ${DISTDIR}/${A} --extract ${WORKDIR} &> /dev/null
	eend $? || die "unpack failed"

	mkdir -p ${WORKDIR}/extra
	einfo "Unpacking fglrx_sample_source.tgz..."
	tar --no-same-owner -C ${WORKDIR}/extra/ -zxf \
		${WORKDIR}/common/usr/src/ATI/fglrx_sample_source.tgz \
		|| die "Failed to unpack fglrx_sample_source.tgz!"
	# Defining USE_GLU allows this to compile with NVIDIA headers just fine
	sed -e "s:-I/usr/X11R6/include:-D USE_GLU -I/usr/X11R6/include:" \
		-i ${WORKDIR}/extra/fgl_glxgears/Makefile.Linux || die

	mkdir -p ${WORKDIR}/extra/fglrx_panel
	einfo "Unpacking fglrx_panel_sources.tgz..."
	tar --no-same-owner -C ${WORKDIR}/extra/fglrx_panel/ -zxf \
		${WORKDIR}/common/usr/src/ATI/fglrx_panel_sources.tgz \
		|| die "Failed to unpack fglrx_panel_sources.tgz!"
	cd ${WORKDIR}/extra/fglrx_panel
	epatch ${DISTDIR}/ati-drivers-extra-8.19.10-improvements.patch.bz2
	sed -e "s:"${OLDBIN}":"${ATIBIN}":"\
		-i ${WORKDIR}/extra/fglrx_panel/Makefile

	}

src_compile() {
	einfo "Building fgl_glxgears"
	cd ${WORKDIR}/extra/fgl_glxgears
	make -f Makefile.Linux || ewarn "fgl_glxgears not build!"

	if use qt
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

	if use qt
	then
		doexe ${WORKDIR}/extra/fglrx_panel/fireglcontrol

		insinto /usr/share/applications/
		doins ${DISTDIR}/fireglcontrol.desktop

		insinto /usr/share/pixmaps/
		doins ${WORKDIR}/extra/fglrx_panel/ati.xpm
	else
		# Removing unused stuff
		rm -rf ${WORKDIR}/usr/share/{applnk,gnome,icons,pixmaps}
	fi
}
