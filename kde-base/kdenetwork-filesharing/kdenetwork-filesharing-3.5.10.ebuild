# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdenetwork-filesharing/kdenetwork-filesharing-3.5.10.ebuild,v 1.2 2009/05/31 19:31:07 nixnut Exp $

KMNAME=kdenetwork
KMMODULE=filesharing
EAPI="1"
inherit kde-meta eutils

DESCRIPTION="kcontrol filesharing config module for NFS, SMB etc"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="kdehiddenvisibility"
