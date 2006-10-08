# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-opengl/eselect-opengl-1.0.4.ebuild,v 1.2 2006/10/08 13:11:41 kugelfang Exp $

inherit multilib

DESCRIPTION="Utility to change the OpenGL interface being used"
HOMEPAGE="http://www.gentoo.org/"

# Source:
# http://oss.sgi.com/projects/ogl-sample/ABI/glext.h
# http://oss.sgi.com/projects/ogl-sample/ABI/glxext.h

GLEXT="29"
GLXEXT="11"

SRC_URI="mirror://gentoo/glext.h-${GLEXT}.bz2
	 mirror://gentoo/glxext.h-${GLXEXT}.bz2
	 mirror://gentoo/opengl.eselect-${PV}.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""
RESTRICT="multilib-pkg-force"

DEPEND="app-arch/bzip2"
RDEPEND=">=app-admin/eselect-1.0.3"

S=${WORKDIR}

src_unpack() {
	unpack ${A}

	mv opengl.eselect-${PV} opengl.eselect
	mv glext.h-${GLEXT} glext.h
	mv glxext.h-${GLXEXT} glxext.h

	# Small bugfix
	sed -i 's/ACTION/action/' opengl.eselect
}

pkg_preinst() {
	# It needs to be before 04multilib
	[ -f "${ROOT}/etc/env.d/09opengl" ] && mv ${ROOT}/etc/env.d/09opengl ${ROOT}/etc/env.d/03opengl

	OABI="${ABI}"
	for ABI in $(get_install_abis); do
		if [ -e "${ROOT}/usr/$(get_libdir)/opengl/xorg-x11/lib/libMesaGL.so" ]; then
			einfo "Removing libMesaGL.so from xorg-x11 profile.  See bug #47598."
			rm -f ${ROOT}/usr/$(get_libdir)/opengl/xorg-x11/lib/libMesaGL.so
		fi
		if [ -e "${ROOT}/usr/$(get_libdir)/libMesaGL.so" ]; then
			einfo "Removing libMesaGL.so from /usr/$(get_libdir).  See bug #47598."
			rm -f ${ROOT}/usr/$(get_libdir)/libMesaGL.so
		fi

		for f in ${ROOT}/usr/$(get_libdir)/libGL.so.* ${ROOT}/usr/$(get_libdir)/libGLcore.so.* ${ROOT}/usr/$(get_libdir)/libnvidia-tls* ${ROOT}/usr/$(get_libdir)/tls/libnvidia-tls* ; do
			[[ -e ${f} ]] && rm -f ${f}
		done
	done
	ABI="${OABI}"
	unset OABI
}

pkg_postinst() {
	local impl="$(eselect opengl show)"
	if [[ -n "${impl}" ]] ; then
		eselect opengl set "${impl}"
	fi
}

src_install() {
	insinto /usr/share/eselect/modules
	doins opengl.eselect

	# MULTILIB-CLEANUP: Fix this when FEATURES=multilib-pkg is in portage
	local MLTEST=$(type dyn_unpack)
	if has_multilib_profile && [ "${MLTEST/set_abi}" = "${MLTEST}" ]; then
		OABI="${ABI}"
		for ABI in $(get_install_abis); do
			# Install default glext.h
			insinto /usr/$(get_libdir)/opengl/global/include
			doins ${WORKDIR}/glext.h || die
			doins ${WORKDIR}/glxext.h || die
		done
		ABI="${OABI}"
		unset OABI
	else
		# Install default glext.h
		insinto /usr/$(get_libdir)/opengl/global/include
		doins ${WORKDIR}/glext.h || die
		doins ${WORKDIR}/glxext.h || die
	fi
}
