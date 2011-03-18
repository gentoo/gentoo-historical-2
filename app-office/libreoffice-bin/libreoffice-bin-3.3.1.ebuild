# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/libreoffice-bin/libreoffice-bin-3.3.1.ebuild,v 1.7 2011/03/18 22:54:58 suka Exp $

EAPI="3"

inherit eutils fdo-mime gnome2-utils pax-utils prefix rpm multilib

IUSE="gnome java offlinehelp"

MY_PV="${PV/_/-}"
MY_PV2="${PV}rc2"
BVER="3.3.1-8"
BVER2="3.3-8"
UREVER="1.7.0-8"
BASIS="libobasis3.3"
BASIS2="basis3.3"
NM1="libreoffice"
NM2="${NM1}3"
NM3="${NM2}.3"
FILEPATH="http://download.documentfoundation.org/${NM1}/stable/${PV}/rpm/"

if [ "${ARCH}" = "amd64" ] ; then
	XARCH="x86_64"
	XARCH2="x86-64"
else
	XARCH="i586"
	XARCH2="x86"
fi

S="${WORKDIR}/en-US/RPMS"
UP="LibO_${MY_PV2}_Linux_${XARCH2}_install-rpm_en-US/RPMS"
DESCRIPTION="LibreOffice productivity suite."

SRC_URI="amd64? ( ${FILEPATH}/x86_64/LibO_${PV}_Linux_x86-64_install-rpm_en-US.tar.gz
		offlinehelp? ( ${FILEPATH}/x86_64/LibO_${PV}_Linux_x86-64_helppack-rpm_en-US.tar.gz ) )
	x86? ( ${FILEPATH}/x86/LibO_${PV}_Linux_x86_install-rpm_en-US.tar.gz
		offlinehelp? ( ${FILEPATH}/x86/LibO_${PV}_Linux_x86_helppack-rpm_en-US.tar.gz ) )"

LANGS="af ar as ast be_BY bg bn bo br brx bs ca ca_XV cs cy da de dgo dz el en en_GB en_ZA eo es et eu fa fi fr ga gl gu he hi hr hu id is it ja ka kk km kn ko kok ks ku lo lt lv mai mk ml mn mni mr my nb ne nl nn nr ns oc om or pa_IN pl pt pt_BR ro ru rw sa_IN sat sd sh si sk sl sq sr ss st sv sw_TZ ta te tg th tn tr ts ug uk uz ve vi xh zh_CN zh_TW zu"

for X in ${LANGS} ; do
	[[ ${X} != "en" ]] && SRC_URI="${SRC_URI} linguas_${X}? (
		amd64? ( "${FILEPATH}"/x86_64/LibO_${PV}_Linux_x86-64_langpack-rpm_${X/_/-}.tar.gz
			offlinehelp? ( "${FILEPATH}"/x86_64/LibO_${PV}_Linux_x86-64_helppack-rpm_${X/_/-}.tar.gz ) )
		x86? ( "${FILEPATH}"/x86/LibO_${PV}_Linux_x86_langpack-rpm_${X/_/-}.tar.gz
			offlinehelp? ( "${FILEPATH}"/x86/LibO_${PV}_Linux_x86_helppack-rpm_${X/_/-}.tar.gz ) ) )"
	IUSE="${IUSE} linguas_${X}"
done

HOMEPAGE="http://www.libreoffice.org"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="!app-office/libreoffice
	!app-office/openoffice
	!app-office/openoffice-bin
	x11-libs/libXaw
	!prefix? ( sys-libs/glibc )
	>=dev-lang/perl-5.0
	app-arch/zip
	app-arch/unzip
	x11-libs/libXinerama
	>=media-libs/freetype-2.1.10-r2"

DEPEND="${RDEPEND}
	sys-apps/findutils"

PDEPEND="java? ( >=virtual/jre-1.5 )"

RESTRICT="strip"

QA_EXECSTACK="usr/$(get_libdir)/${NM1}/${BASIS2}/program/*
	usr/$(get_libdir)/${NM1}/ure/lib/*"
QA_TEXTRELS="usr/$(get_libdir)/${NM1}/ure/lib/*"
QA_PRESTRIPPED="usr/$(get_libdir)/${NM1}/${BASIS2}/program/*
	usr/$(get_libdir)/${NM1}/${BASIS2}/program/python-core-2.6.1/lib/lib-dynload/*
	usr/$(get_libdir)/${NM1}/program/*
	usr/$(get_libdir)/${NM1}/ure/bin/*
	usr/$(get_libdir)/${NM1}/ure/lib/*"

src_unpack() {

	unpack ${A}

	cp "${FILESDIR}"/{50-${PN},wrapper.in} "${T}"
	eprefixify "${T}"/{50-${PN},wrapper.in}

	for i in base binfilter calc core01 core02 core03 core04 core05 core06 \
		core07 draw graphicfilter images impress math ogltrans ooofonts \
		ooolinguistic pyuno testtool writer xsltfilter ; do
		rpm_unpack "./${UP}/${BASIS}-${i}-${BVER}.${XARCH}.rpm"
	done

	rpm_unpack "./${UP}/${NM2}-${BVER}.${XARCH}.rpm"
	rpm_unpack "./${UP}/${NM2}-ure-${UREVER}.${XARCH}.rpm"

	for j in base calc draw impress math writer; do
		rpm_unpack "./${UP}/${NM2}-${j}-${BVER}.${XARCH}.rpm"
	done

	rpm_unpack "./${UP}/desktop-integration/${NM3}-freedesktop-menus-${BVER2}.noarch.rpm"

	use gnome && rpm_unpack "./${UP}/${BASIS}-gnome-integration-${BVER}.${XARCH}.rpm"
	use java && rpm_unpack "./${UP}/${BASIS}-javafilter-${BVER}.${XARCH}.rpm"

	# Extensions
	for k in mediawiki-publisher nlpsolver pdf-import presentation-minimizer presenter-screen report-builder; do
		rpm_unpack "./${UP}/${BASIS}-extension-${k}-${BVER}.${XARCH}.rpm"
	done

	# English support installed by default
	rpm_unpack "./${UP}/${BASIS}-en-US-${BVER}.${XARCH}.rpm"
	rpm_unpack "./${UP}/${NM2}-en-US-${BVER}.${XARCH}.rpm"
	rpm_unpack "./${UP}/${NM2}-dict-en-${BVER}.${XARCH}.rpm"
	use offlinehelp && rpm_unpack "./LibO_${MY_PV2}_Linux_${XARCH2}_helppack-rpm_en-US/RPMS//${BASIS}-en-US-help-${BVER}.${XARCH}.rpm"
	for s in base binfilter calc math res writer ; do
		rpm_unpack "./${UP}/${BASIS}-en-US-${s}-${BVER}.${XARCH}.rpm"
	done

	# Localization
	strip-linguas ${LANGS}
	for l in ${LINGUAS}; do
		m="${l/_/-}"
		if [[ ${m} != "en" ]] ; then
			LANGDIR="LibO_${MY_PV2}_Linux_${XARCH2}_langpack-rpm_${m}/RPMS/"
			rpm_unpack "./${LANGDIR}/${BASIS}-${m}-${BVER}.${XARCH}.rpm"
			rpm_unpack "./${LANGDIR}/${NM2}-${m}-${BVER}.${XARCH}.rpm"
			for n in base binfilter calc math res writer; do
				rpm_unpack "./${LANGDIR}/${BASIS}-${m}-${n}-${BVER}.${XARCH}.rpm"
			done

			for DICT_FILE in `find "./${LANGDIR}" -name "${NM2}-dict-*-${BVER}.${XARCH}.rpm"`; do
				DICT_REGEX="s/${NM2}-dict-(.*?)-${BVER}.${XARCH}.rpm/\1/"
				DICT_LOCALE=`basename "$DICT_FILE" | sed -E "${DICT_REGEX}"`
				if [[ -n "${DICT_LOCALE}" && ! -d "${WORKDIR}/opt/${NM1}/share/extensions/dict-${DICT_LOCALE}" ]] ; then
					rpm_unpack "${DICT_FILE}"
				fi
			done

			# Help files
			if use offlinehelp; then
				LANGDIR2="LibO_${MY_PV2}_Linux_${XARCH2}_helppack-rpm_${m}/RPMS/"
				rpm_unpack "./${LANGDIR2}/${BASIS}-${m}-help-${BVER}.${XARCH}.rpm"
			fi
		fi
	done

}

src_install () {

	INSTDIR="/usr/$(get_libdir)/${NM1}"
	dodir ${INSTDIR}
	mv "${WORKDIR}"/opt/${NM1}/* "${ED}${INSTDIR}" || die

	#Menu entries, icons and mime-types
	cd "${ED}${INSTDIR}/share/xdg/"
	for desk in base calc draw impress javafilter math printeradmin qstart startcenter writer; do
		if [ "${desk}" = "javafilter" ] ; then
			use java || { rm javafilter.desktop; continue; }
		fi
		mv ${desk}.desktop ${NM1}-${desk}.desktop
		domenu ${NM1}-${desk}.desktop
	done
	insinto /usr/share
	doins -r "${WORKDIR}"/usr/share/icons
	doins -r "${WORKDIR}"/usr/share/mime

	# Install wrapper script
	newbin "${T}/wrapper.in" ${NM1}
	sed -i -e s/LIBDIR/$(get_libdir)/g "${ED}/usr/bin/${NM1}" || die

	# Component symlinks
	for app in base calc draw impress math writer; do
		dosym ${INSTDIR}/program/s${app} /usr/bin/lo${app}
	done

	dosym ${INSTDIR}/program/spadmin /usr/bin/${NM1}-printeradmin
	dosym ${INSTDIR}/program/soffice /usr/bin/soffice

	rm -f "${ED}${INSTDIR}/basis-link" || die
	dosym ${INSTDIR}/${BASIS2} ${INSTDIR}/basis-link

	# Non-java weirdness see bug #99366
	use !java && rm -f "${ED}${INSTDIR}/ure/bin/javaldx"

	# prevent revdep-rebuild from attempting to rebuild all the time
	insinto /etc/revdep-rebuild && doins "${T}/50-${PN}"

}

pkg_preinst() {

	use gnome && gnome2_icon_savelist

}

pkg_postinst() {

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	use gnome && gnome2_icon_cache_update

	pax-mark -m "${EPREFIX}"/usr/$(get_libdir)/${NM1}/program/soffice.bin

}

pkg_postrm() {

	fdo-mime_desktop_database_update
	use gnome && gnome2_icon_cache_update

}
