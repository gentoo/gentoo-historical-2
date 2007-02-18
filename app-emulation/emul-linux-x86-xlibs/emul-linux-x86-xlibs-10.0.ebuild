# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-xlibs/emul-linux-x86-xlibs-10.0.ebuild,v 1.1 2007/02/18 10:48:41 blubb Exp $

DESCRIPTION="Provides precompiled 32bit libraries"
HOMEPAGE="http://amd64.gentoo.org/emul/content.xml"
SRC_URI="mirror://gentoo/fontconfig-2.4.2.tbz2
	mirror://gentoo/freetype-2.1.10-r2.tbz2
	mirror://gentoo/glut-3.7.1.tbz2
	mirror://gentoo/libdrm-2.0.2.tbz2
	mirror://gentoo/libICE-1.0.1.tbz2
	mirror://gentoo/libSM-1.0.1.tbz2
	mirror://gentoo/libX11-1.0.3.tbz2
	mirror://gentoo/libXau-1.0.2.tbz2
	mirror://gentoo/libXaw-1.0.2.tbz2
	mirror://gentoo/libXcomposite-0.3.tbz2
	mirror://gentoo/libXcursor-1.1.7.tbz2
	mirror://gentoo/libXdamage-1.0.3.tbz2
	mirror://gentoo/libXdmcp-1.0.1.tbz2
	mirror://gentoo/libXext-1.0.1.tbz2
	mirror://gentoo/libXfixes-4.0.1.tbz2
	mirror://gentoo/libXft-2.1.10.tbz2
	mirror://gentoo/libXi-1.0.1.tbz2
	mirror://gentoo/libXinerama-1.0.1.tbz2
	mirror://gentoo/libXmu-1.0.2.tbz2
	mirror://gentoo/libXp-1.0.0.tbz2
	mirror://gentoo/libXpm-3.5.5.tbz2
	mirror://gentoo/libXrandr-1.1.1.tbz2
	mirror://gentoo/libXrender-0.9.1.tbz2
	mirror://gentoo/libXScrnSaver-1.1.0.tbz2
	mirror://gentoo/libXt-1.0.2.tbz2
	mirror://gentoo/libXtst-1.0.1.tbz2
	mirror://gentoo/libXv-1.0.1.tbz2
	mirror://gentoo/libXvMC-1.0.2.tbz2
	mirror://gentoo/libXxf86dga-1.0.1.tbz2
	mirror://gentoo/libXxf86vm-1.0.1.tbz2
	mirror://gentoo/mesa-6.5.1-r1.tbz2
	mirror://gentoo/openmotif-2.2.3-r9.tbz2"

LICENSE="fontconfig FTL GPL-2 LGPL-2 glut libdrm libICE libSM libX11 libXau
		libXaw libXcomposite libXcursor libXdamage libXdmcp libXext libXfixes libXft
		libXi libXinerama libXmu libXp libXpm libXrandr libXrender libXScrnSaver libXt
		libXtst libXv libXvMC libXxf86dga libXxf86dga libXxf86vm"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="opengl"

RESTRICT="nostrip"
S=${WORKDIR}

DEPEND=""
RDEPEND=">=app-emulation/emul-linux-x86-baselibs-10.0
	x11-libs/libX11
	opengl? ( app-admin/eselect-opengl )"

pkg_setup() {
	einfo "Note: You can safely ignore the 'trailing garbage after EOF'"
	einfo "      warnings below"
}

src_unpack() {
	unpack ${A}

	# we only want the libs
	ALLOWED="${S}/etc/env.d"
	find ${S} ! -type d ! -name '*.so*' | grep -v "${ALLOWED}" | xargs rm -f
}

src_install() {
	for dir in etc/env.d etc/revdep-rebuild ; do
		if [[ -d ${S}/${dir} ]] ; then
			for f in ${S}/${dir}/* ; do
				mv -f $f{,-emul}
			done
		fi
	done

	# remove void directories or portage will show weird output
	find ${S} -type d -depth | xargs rmdir 2&>/dev/null

	cp -a "${WORKDIR}"/* "${D}"/ || die "copying files failed!"
}

pkg_postinst() {
	#update GL symlinks
	use opengl && eselect opengl set --use-old
}
