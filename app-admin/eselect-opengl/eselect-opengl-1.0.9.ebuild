# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/eselect-opengl/eselect-opengl-1.0.9.ebuild,v 1.1 2009/10/30 20:50:17 scarabeus Exp $

inherit multilib

DESCRIPTION="Utility to change the OpenGL interface being used"
HOMEPAGE="http://www.gentoo.org/"

# Source:
# http://www.opengl.org/registry/api/glext.h
# http://www.opengl.org/registry/api/glxext.h

GLEXT="56"
GLXEXT="25"

#MIRROR="mirror://gentoo/"
MIRROR="http://dev.gentooexperimental.org/~scarabeus/"
SRC_URI="${MIRROR}/glext.h.${GLEXT}.bz2
	${MIRROR}/glxext.h.${GLXEXT}.bz2
	${MIRROR}/opengl.eselect-${PV}.bz2"

LICENSE="GPL-2"
SLOT="0"
# -* to give time for headers to hit mirrors...
#KEYWORDS="-*"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""
EMULTILIB_PKG="true"

DEPEND="app-arch/bzip2"
RDEPEND=">=app-admin/eselect-1.1"

S=${WORKDIR}

src_unpack() {
	unpack ${A}

	mv opengl.eselect-${PV} opengl.eselect
}

pkg_preinst() {
	# It needs to be before 04multilib
	[[ -f "${ROOT}/etc/env.d/09opengl" ]] && mv ${ROOT}/etc/env.d/09opengl ${ROOT}/etc/env.d/03opengl

	OABI="${ABI}"
	for ABI in $(get_install_abis); do
		if [[ -e "${ROOT}/usr/$(get_libdir)/opengl/xorg-x11/lib/libMesaGL.so" ]]
		then
			einfo "Removing libMesaGL.so from xorg-x11 profile. See bug #47598."
			rm -f "${ROOT}/usr/$(get_libdir)/opengl/xorg-x11/lib/libMesaGL.so"
		fi
		if [[ -e "${ROOT}/usr/$(get_libdir)/libMesaGL.so" ]]
		then
			einfo "Removing libMesaGL.so from /usr/$(get_libdir).  See bug #47598."
			rm -f "${ROOT}/usr/$(get_libdir)/libMesaGL.so"
		fi

		for f in "${ROOT}/usr/$(get_libdir)"/libGL.so.* "${ROOT}/usr/$(get_libdir)"/libGLcore.so.* "${ROOT}/usr/$(get_libdir)"/libnvidia-tls* "${ROOT}/usr/$(get_libdir)"/tls/libnvidia-tls* ; do
			[[ -e ${f} ]] && rm -f "${f}"
		done
	done
	ABI="${OABI}"
	unset OABI
}

pkg_postinst() {
	local impl="$(eselect opengl show)"
	if [[ -n "${impl}"  && "${impl}" != '(none)' ]] ; then
		eselect opengl set "${impl}"
	fi

	# info about removal of .la file
	elog "eselect-opengl strips the libGL.la file."
	elog "This file was broken by design and thus removed."
	elog "For fixing all sort of configure issues please run:"
	elog "  lafilefixer --justfixit"
	elog "or run revdep-rebuild."
	elog "(lafilefixer package can be found as dev-util/lafilefixer)"
}

src_install() {
	insinto /usr/share/eselect/modules
	doins opengl.eselect

	# Install default glext.h
	insinto "/usr/$(get_libdir)/opengl/global/include"
	cd "${WORKDIR}"
	newins glext.h.${GLEXT} glext.h || die
	newins glxext.h.${GLXEXT} glxext.h || die
}
