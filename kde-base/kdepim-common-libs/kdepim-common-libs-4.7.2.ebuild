# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdepim-common-libs/kdepim-common-libs-4.7.2.ebuild,v 1.1 2011/10/06 18:11:03 alexxy Exp $

EAPI=4

KMNAME="kdepim"
KMNOMODULE="true"
KDE_SCM="git"
inherit kde4-meta

DESCRIPTION="Common libraries for KDE PIM apps"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	app-crypt/gpgme
	>=app-office/akonadi-server-1.3.60
	>=dev-libs/shared-desktop-ontologies-0.6.50
	$(add_kdebase_dep kdepimlibs 'semantic-desktop')
"
RDEPEND="${DEPEND}
	app-crypt/gnupg
	$(add_kdebase_dep kdepim-runtime)
"

# @Since >4.4.76 merged here
add_blocker akonadi
add_blocker libkdepim
add_blocker libkleo
add_blocker libkpgp
add_blocker kaddressbook '<4.4.90'
add_blocker kmail '<4.4.80'
add_blocker korganizer '<4.5.67'

KMEXTRA="
	akonadi_next/
	calendarsupport/
	calendarviews/
	incidenceeditor-ng/
	libkdepim/
	libkdepimdbusinterfaces/
	libkleo/
	libkpgp/
	kdgantt2/
	messagecomposer/
	messagecore/
	messagelist/
	messageviewer/
	nepomuk_email_feeder/
	ontologies/
	templateparser/
"

KMEXTRACTONLY="
	kleopatra/
	kmail/
	knode/org.kde.knode.xml
	korganizer/korgac/org.kde.korganizer.KOrgac.xml
	korganizer/org.kde.korganizer.Korganizer.xml
"

KMSAVELIBS="true"
