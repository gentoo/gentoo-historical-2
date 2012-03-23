# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/sgml-catalog.eclass,v 1.18 2012/03/23 06:16:15 floppym Exp $
#
# Author Matthew Turk <satai@gentoo.org>

inherit base

DEPEND=">=app-text/sgml-common-0.6.3-r2"


# List of catalogs to install
SGML_TOINSTALL=""


sgml-catalog_cat_include() {
	debug-print function $FUNCNAME $*
	SGML_TOINSTALL="${SGML_TOINSTALL} ${1}:${2}"
}

sgml-catalog_cat_doinstall() {
	debug-print function $FUNCNAME $*
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=
	"${EPREFIX}"/usr/bin/install-catalog --add "${EPREFIX}$1" "${EPREFIX}$2" &>/dev/null
}

sgml-catalog_cat_doremove() {
	debug-print function $FUNCNAME $*
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=
	"${EPREFIX}"/usr/bin/install-catalog --remove "${EPREFIX}$1" "${EPREFIX}$2" &>/dev/null
}

sgml-catalog_pkg_postinst() {
	debug-print function $FUNCNAME $*
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=

	for entry in ${SGML_TOINSTALL}; do
		arg1=${entry%%:*}
		arg2=${entry#*:}
		if [ ! -e "${EPREFIX}"${arg2} ]
		then
			ewarn "${EPREFIX}${arg2} doesn't appear to exist, although it ought to!"
			continue
		fi
		einfo "Now adding ${EPREFIX}${arg2} to ${EPREFIX}${arg1} and ${EPREFIX}/etc/sgml/catalog"
		sgml-catalog_cat_doinstall ${arg1} ${arg2}
	done
	sgml-catalog_cleanup
}

sgml-catalog_pkg_prerm() {
	sgml-catalog_cleanup
}

sgml-catalog_pkg_postrm() {
	debug-print function $FUNCNAME $*
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=

	for entry in ${SGML_TOINSTALL}; do
		arg1=${entry%%:*}
		arg2=${entry#*:}
		einfo "Now removing ${EPREFIX}${arg2} from ${EPREFIX}${arg1} and ${EPREFIX}/etc/sgml/catalog"
		sgml-catalog_cat_doremove ${arg1} ${arg2}
	done
}

sgml-catalog_cleanup() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=
	if [ -e "${EPREFIX}/usr/bin/gensgmlenv" ]
	then
		einfo Regenerating SGML environment variables ...
		gensgmlenv
		grep -v export "${EPREFIX}/etc/sgml/sgml.env" > "${EPREFIX}/etc/env.d/93sgmltools-lite"
	fi
}

sgml-catalog_src_compile() {
	return
}

EXPORT_FUNCTIONS pkg_postrm pkg_postinst src_compile pkg_prerm
