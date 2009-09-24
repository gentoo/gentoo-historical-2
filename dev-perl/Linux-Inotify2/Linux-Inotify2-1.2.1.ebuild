# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Linux-Inotify2/Linux-Inotify2-1.2.1.ebuild,v 1.1 2009/09/24 06:22:25 tove Exp $

EAPI=2

inherit versionator
MODULE_AUTHOR=MLEHMANN
MY_P=${PN}-$(get_major_version ).$(delete_all_version_separators $(get_after_major_version ) )
S=${WORKDIR}/${MY_P}
inherit perl-module

DESCRIPTION="scalable directory/file change notification"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/common-sense"
RDEPEND="${DEPEND}"

SRC_TEST="do"
