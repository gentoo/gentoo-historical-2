# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Script/Test-Script-1.05.ebuild,v 1.3 2009/10/03 05:25:59 josejx Exp $

EAPI=2

MODULE_AUTHOR=ADAMK
inherit perl-module

DESCRIPTION="Cross-platform basic tests for scripts"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE=""

RDEPEND="virtual/perl-File-Spec
	dev-perl/Probe-Perl
	dev-perl/IPC-Run3
	virtual/perl-Test-Simple"
DEPEND="${RDEPEND}"

SRC_TEST=do
