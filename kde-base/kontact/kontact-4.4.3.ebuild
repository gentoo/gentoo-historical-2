# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kontact/kontact-4.4.3.ebuild,v 1.1 2010/05/03 21:08:03 alexxy Exp $

EAPI="3"

KMNAME="kdepim"
inherit kde4-meta

DESCRIPTION="KDE personal information manager"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +handbook"

DEPEND="
	$(add_kdebase_dep kdepimlibs)
	$(add_kdebase_dep libkdepim)
"
RDEPEND="${DEPEND}"

KMLOADLIBS="libkdepim"
KMSAVELIBS="true"

# We remove plugins that are related to external kdepim programs. This way
# kontact doesn't have to depend on all programs it has plugins for.
# kcontactmanager gone from kdesvn
#
# xml targets from kmail/ are being uncommented by kde4-meta.eclass
KMEXTRACTONLY="
	kmail/
	kontact/plugins/akregator/
	kontact/plugins/kaddressbook/
	kontact/plugins/kjots/
	kontact/plugins/kmail/
	kontact/plugins/knode/
	kontact/plugins/knotes/
	kontact/plugins/korganizer/
	kontact/plugins/ktimetracker/
	kontact/plugins/planner/
	kontact/plugins/specialdates/
"

src_unpack() {
	if use handbook; then
		KMEXTRA+="
			doc/kontact-admin/
		"
	fi

	kde4-meta_src_unpack
}
