# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kmail/kmail-4.9.5.ebuild,v 1.2 2013/01/27 12:18:53 ago Exp $

EAPI=4

KDE_HANDBOOK="optional"
KMNAME="kdepim"
VIRTUALX_REQUIRED=test
inherit flag-o-matic kde4-meta

DESCRIPTION="KMail is the email component of Kontact, the integrated personal information manager of KDE."
KEYWORDS="amd64 ~arm ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kdepimlibs 'semantic-desktop')
	$(add_kdebase_dep korganizer)
	$(add_kdebase_dep kdepim-common-libs)
"
RDEPEND="${DEPEND}"

RESTRICT="test"
# bug 393147

KMEXTRACTONLY="
	akonadi_next/
	archivemailagent/
	calendarsupport/
	korganizer/
	kresources/
	libkleo/
	libkpgp/
	libkdepimdbusinterfaces/
	kdgantt2/
"
KMCOMPILEONLY="
	messagecomposer/
	messagecore/
	messagelist/
	messageviewer/
	templateparser/
	incidenceeditor-ng/
	calendarsupport/
"
KMEXTRA="
	archivemailagent/
	backupmail/
	kmailcvt/
	ksendemail/
	importwizard/
	libksieve/
	mailcommon/
	mailfilteragent/
	mailimporter/
	ontologies/
	plugins/messageviewer/
"

KMLOADLIBS="kdepim-common-libs"

src_configure() {
	# Bug 308903
	use ppc64 && append-flags -mminimal-toc

	kde4-meta_src_configure
}

src_compile() {
	kde4-meta_src_compile kmail_xml
	kde4-meta_src_compile
}

pkg_postinst() {
	kde4-meta_pkg_postinst

	if ! has_version kde-base/kdepim-kresources:${SLOT}; then
		echo
		elog "For groupware functionality, please install kde-base/kdepim-kresources:${SLOT}"
		echo
	fi
	if ! has_version kde-base/kleopatra:${SLOT}; then
		echo
		elog "For certificate management and the gnupg log viewer, please install kde-base/kleopatra:${SLOT}"
		echo
	fi
}
