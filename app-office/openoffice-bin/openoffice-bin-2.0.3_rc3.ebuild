# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/openoffice-bin/openoffice-bin-2.0.3_rc3.ebuild,v 1.1 2006/05/24 09:11:39 suka Exp $

inherit eutils fdo-mime rpm multilib

IUSE="gnome java"

MY_PV="${PV/_/}"
MY_PV2="${MY_PV}_060519"
MY_PV3="${PV/_rc3/}-3"
MILESTONE="OOC680_m3"
PACKED="${MILESTONE}_native_packed-1"
BUILDID="9031"
S="${WORKDIR}/${PACKED}_en-US.${BUILDID}/RPMS"
DESCRIPTION="OpenOffice productivity suite"

LANGPACK="OOo_${MY_PV2}_LinuxIntel_langpack"
LANGPACKPATH="http://oootranslation.services.openoffice.org/pub/OpenOffice.org/${MY_PV}/${LANGPACK}"
LANGSUFFIX="${MY_PV3}.i586.tar.gz"

SRC_URI="mirror://openoffice/contrib/rc/${MY_PV}/OOo_${MY_PV2}_LinuxIntel_install.tar.gz
	linguas_af? ( ${LANGPACKPATH}_af.tar.gz )
	linguas_as_IN? ( ${LANGPACKPATH}_as-IN.tar.gz )
	linguas_be_BY? ( ${LANGPACKPATH}_be-BY.tar.gz )
	linguas_bg? ( ${LANGPACKPATH}_bg.tar.gz )
	linguas_bs? ( ${LANGPACKPATH}_bs.tar.gz )
	linguas_ca? ( ${LANGPACKPATH}_ca.tar.gz )
	linguas_cs? ( ${LANGPACKPATH}_cs.tar.gz )
	linguas_cy? ( ${LANGPACKPATH}_cy.tar.gz )
	linguas_da? ( ${LANGPACKPATH}_da.tar.gz )
	linguas_de? ( ${LANGPACKPATH}_de.tar.gz )
	linguas_el? ( ${LANGPACKPATH}_el.tar.gz )
	linguas_en_GB? ( ${LANGPACKPATH}_en-GB.tar.gz )
	linguas_en_ZA? ( ${LANGPACKPATH}_en-ZA.tar.gz )
	linguas_es? ( ${LANGPACKPATH}_es.tar.gz )
	linguas_et? ( ${LANGPACKPATH}_et.tar.gz )
	linguas_fa? ( ${LANGPACKPATH}_fa.tar.gz )
	linguas_fi? ( ${LANGPACKPATH}_fi.tar.gz )
	linguas_fr? ( ${LANGPACKPATH}_fr.tar.gz )
	linguas_gu_IN? ( ${LANGPACKPATH}_gu-IN.tar.gz )
	linguas_he? ( ${LANGPACKPATH}_he.tar.gz )
	linguas_hi_IN? ( ${LANGPACKPATH}_hi-IN.tar.gz )
	linguas_hr? ( ${LANGPACKPATH}_hr.tar.gz )
	linguas_hu? ( ${LANGPACKPATH}_hu.tar.gz )
	linguas_it? ( ${LANGPACKPATH}_it.tar.gz )
	linguas_ja? ( ${LANGPACKPATH}_ja.tar.gz )
	linguas_km? ( ${LANGPACKPATH}_km.tar.gz )
	linguas_ko? ( ${LANGPACKPATH}_ko.tar.gz )
	linguas_lt? ( ${LANGPACKPATH}_lt.tar.gz )
	linguas_mk? ( ${LANGPACKPATH}_mk.tar.gz )
	linguas_ml_IN? ( ${LANGPACKPATH}_ml-IN.tar.gz )
	linguas_mr_IN? ( ${LANGPACKPATH}_mr-IN.tar.gz )
	linguas_nb? ( ${LANGPACKPATH}_nb.tar.gz )
	linguas_nl? ( ${LANGPACKPATH}_nl.tar.gz )
	linguas_nn? ( ${LANGPACKPATH}_nn.tar.gz )
	linguas_ns? ( ${LANGPACKPATH}_ns.tar.gz )
	linguas_or_IN? ( ${LANGPACKPATH}_or-IN.tar.gz )
	linguas_pa_IN? ( ${LANGPACKPATH}_pa-IN.tar.gz )
	linguas_pl? ( ${LANGPACKPATH}_pl.tar.gz )
	linguas_pt_BR? ( ${LANGPACKPATH}_pt-BR.tar.gz )
	linguas_ru? ( ${LANGPACKPATH}_ru.tar.gz )
	linguas_rw? ( ${LANGPACKPATH}_rw.tar.gz )
	linguas_sh_YU? ( ${LANGPACKPATH}_sh-YU.tar.gz )
	linguas_sk? ( ${LANGPACKPATH}_sk.tar.gz )
	linguas_sl? ( ${LANGPACKPATH}_sl.tar.gz )
	linguas_sr_CS? ( ${LANGPACKPATH}_sr-CS.tar.gz )
	linguas_st? ( ${LANGPACKPATH}_st.tar.gz )
	linguas_sv? ( ${LANGPACKPATH}_sv.tar.gz )
	linguas_sw_TZ? ( ${LANGPACKPATH}_sw-TZ.tar.gz )
	linguas_ta_IN? ( ${LANGPACKPATH}_ta-IN.tar.gz )
	linguas_te_IN? ( ${LANGPACKPATH}_te-IN.tar.gz )
	linguas_tg? ( ${LANGPACKPATH}_tg.tar.gz )
	linguas_th? ( ${LANGPACKPATH}_th.tar.gz )
	linguas_ti_ER? ( ${LANGPACKPATH}_ti-ER.tar.gz )
	linguas_tr? ( ${LANGPACKPATH}_tr.tar.gz )
	linguas_ur_IN? ( ${LANGPACKPATH}_ur-IN.tar.gz )
	linguas_vi? ( ${LANGPACKPATH}_vi.tar.gz )
	linguas_xh? ( ${LANGPACKPATH}_xh.tar.gz )
	linguas_zh_CN? ( ${LANGPACKPATH}_zh-CN.tar.gz )
	linguas_zh_TW? ( ${LANGPACKPATH}_zh-TW.tar.gz )
	linguas_zu? ( ${LANGPACKPATH}_zu.tar.gz )"

HOMEPAGE="http://www.openoffice.org/"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="!app-office/openoffice
	|| ( x11-libs/libXaw virtual/x11 )
	sys-libs/glibc
	>=dev-lang/perl-5.0
	app-arch/zip
	app-arch/unzip
	java? ( !amd64? ( >=virtual/jre-1.4.1 )
		amd64? ( app-emulation/emul-linux-x86-java ) )
	amd64? ( >=app-emulation/emul-linux-x86-xlibs-1.0 )
	linguas_ja? ( >=media-fonts/kochi-substitute-20030809-r3 )
	linguas_zh_CN? ( >=media-fonts/arphicfonts-0.1-r2 )
	linguas_zh_TW? ( >=media-fonts/arphicfonts-0.1-r2 )"

DEPEND="${RDEPEND}
	sys-apps/findutils"

PROVIDE="virtual/ooo"

src_unpack() {

	unpack ${A}

	for i in base calc core01 core02 core03 core03u core04 core04u core05 core05u core06 core07 core08 core09 core10 draw emailmerge impress math writer graphicfilter pyuno testtool xsltfilter ; do
		rpm_unpack ${S}/openoffice.org-${i}-${MY_PV3}.i586.rpm
	done

	rpm_unpack ${S}/desktop-integration/openoffice.org-freedesktop-menus-2.0.3-2.noarch.rpm

	use gnome && rpm_unpack ${S}/openoffice.org-gnome-integration-${MY_PV3}.i586.rpm
	use java && rpm_unpack ${S}/openoffice.org-javafilter-${MY_PV3}.i586.rpm

	strip-linguas en af as_IN be_BY bg bs ca cs cy da de el en_GB en_ZA es et fa fi fr gu_IN he hi_IN hr hu it ja km ko lt mk ml_IN mr_IN nb nl nn ns or_IN pa_IN pl pt_BR ru rw sh_YU sk sl sr_CS st sv sw_TZ ta_IN te_IN tg th ti_ER tr ur_IN vi xh zh_CN zh_TW zu

	for i in ${LINGUAS}; do
		i="${i/_/-}"
		if [ ${i} != "en" ] ; then
			LANGDIR="${WORKDIR}/${PACKED}_${i}.${BUILDID}/RPMS/"
			rpm_unpack ${LANGDIR}/openoffice.org-${i}-${MY_PV3}.i586.rpm
			rpm_unpack ${LANGDIR}/openoffice.org-${i}-help-${MY_PV3}.i586.rpm
			rpm_unpack ${LANGDIR}/openoffice.org-${i}-res-${MY_PV3}.i586.rpm
		fi
	done

}

src_install () {

	#Multilib install dir magic for AMD64
	has_multilib_profile && ABI=x86
	INSTDIR="/usr/$(get_libdir)/openoffice"

	einfo "Installing OpenOffice.org into build root..."
	dodir ${INSTDIR}
	mv ${WORKDIR}/opt/openoffice.org2.0/* ${D}${INSTDIR}

	#Menu entries, icons and mime-types
	cd ${D}${INSTDIR}/share/xdg/
	sed -i -e s/'Exec=openoffice.org-2.0-printeradmin'/'Exec=oopadmin2'/g printeradmin.desktop || die

	for desk in base calc draw impress math printeradmin writer; do
		mv ${desk}.desktop openoffice.org-2.0-${desk}.desktop
		sed -i -e s/openoffice.org-2.0/ooffice2/g openoffice.org-2.0-${desk}.desktop || die
		sed -i -e s/openofficeorg-20-${desk}/ooo-${desk}2/g openoffice.org-2.0-${desk}.desktop || die
		domenu openoffice.org-2.0-${desk}.desktop
		insinto /usr/share/pixmaps
		newins ${WORKDIR}/usr/share/icons/gnome/48x48/apps/openofficeorg-20-${desk}.png ooo-${desk}2.png
	done

	insinto /usr/share/mime/packages
	doins ${WORKDIR}/usr/share/mime/packages/openoffice.org.xml

	# Install wrapper script
	newbin ${FILESDIR}/${PV}/ooo-wrapper2 ooffice2
	sed -i -e s/PV/${PV}/g ${D}/usr/bin/ooffice2 || die
	sed -i -e "s|INSTDIR|${INSTDIR}|g" ${D}/usr/bin/ooffice2 || die

	# Component symlinks
	for app in base calc draw fromtemplate impress math web writer; do
		dosym ooffice2 /usr/bin/oo${app}2
	done

	dosym ${INSTDIR}/program/spadmin.bin /usr/bin/oopadmin2

	# Change user install dir
	sed -i -e s/.openoffice.org2/.ooo-2.0/g ${D}${INSTDIR}/program/bootstraprc || die

	# Non-java weirdness see bug #99366
	use !java && rm -f ${D}${INSTDIR}/program/javaldx
}

pkg_postinst() {

	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update

	[ -x /sbin/chpax ] && [ -e /usr/lib/openoffice/program/soffice.bin ] && chpax -zm /usr/lib/openoffice/program/soffice.bin

	einfo " To start OpenOffice.org, run:"
	einfo
	einfo "   $ ooffice2"
	einfo
	einfo " Also, for individual components, you can use any of:"
	einfo
	einfo " oobase2, oocalc2, oodraw2, oofromtemplate2, ooimpress2, oomath2,"
	einfo " ooweb2 or oowriter2"
}
