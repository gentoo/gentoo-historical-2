# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdenetwork-filesharing/kdenetwork-filesharing-3.4.2.ebuild,v 1.7 2005/12/09 05:40:38 josejx Exp $

KMNAME=kdenetwork
KMMODULE=filesharing
MAXKDEVER=3.4.3
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="kcontrol filesharing config module for NFS, SMB etc"
KEYWORDS="~alpha amd64 ppc ppc64 sparc ~x86"
IUSE=""
