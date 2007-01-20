# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/dmenu/dmenu-2.1.ebuild,v 1.2 2007/01/20 12:14:46 corsair Exp $

inherit toolchain-funcs

DESCRIPTION="a generic, highly customizable, and efficient menu for the X Window System"
HOMEPAGE="http://suckless.org/view/dynamic+window+manager"
SRC_URI="http://suckless.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="savedconfig"

DEPEND="x11-libs/libX11"
RDEPEND=${DEPEND}

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i \
		-e "s/.*strip.*//" \
		Makefile || die "sed failed"

	sed -i \
		-e "s/CFLAGS = -Os/CFLAGS +=/" \
		-e "s/LDFLAGS =/LDFLAGS +=/" \
		config.mk || die "sed failed"

	if use savedconfig; then
		local conf root
		for conf in ${PF} ${P} ${PN}; do
			for root in "${PORTAGE_CONFIGROOT}" "${ROOT}" /; do
				configfile=${root}etc/portage/savedconfig/${conf}.config.h
				if [[ -r ${configfile} ]]; then
					elog "Found your ${configfile} and using it."
					cp -f ${configfile} "${S}"/${PN}.h
					return 0
				fi
			done
		done
		ewarn "Could not locate user configfile, so we will save a default one."
	fi
}

src_compile() {
	local msg
	use savedconfig && msg=", please check the configfile"
	emake CC=$(tc-getCC) || die "emake failed${msg}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install || die "emake install failed"

	insinto /usr/share/${PN}
	newins ${PN}.h ${PF}.config.h

	dodoc README
}

pkg_preinst() {
	if use savedconfig; then
		mv "${D}"/usr/share/${PN}/${PF}.config.h "${T}"/
	fi
}

pkg_postinst() {
	if use savedconfig; then
		local config_dir="${PORTAGE_CONFIGROOT:-${ROOT}}/etc/portage/savedconfig"
		elog "Saving this build config to ${config_dir}/${PF}.config.h"
		einfo "Read this ebuild for more info on how to take advantage of this option."
		mkdir -p "${config_dir}"
		cp "${T}"/${PF}.config.h "${config_dir}"/${PF}.config.h
	fi
	einfo "This ebuild has support for user defined configs"
	einfo "Please read this ebuild for more details and re-emerge as needed"
	einfo "if you want to add or remove functionality for ${PN}"
}
