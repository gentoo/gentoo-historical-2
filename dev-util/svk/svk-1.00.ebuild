# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/svk/svk-1.00.ebuild,v 1.3 2005/05/17 04:21:10 pclouds Exp $

inherit eutils perl-module

MP=${P/svk/SVK}
DESCRIPTION="A decentralized version control system"
SRC_URI="http://www.cpan.org/authors/id/C/CL/CLKAO/${MP}.tar.gz"
HOMEPAGE="http://svk.elixus.org/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~x86 ~ppc"
SRC_TEST="do"
IUSE="crypt"
S=${WORKDIR}/${MP}

DEPEND="${DEPEND}
	>=dev-perl/SVN-Simple-0.27
	>=dev-perl/SVN-Mirror-0.61
	>=dev-perl/PerlIO-via-dynamic-0.11
	>=dev-perl/PerlIO-via-symlink-0.02
	>=dev-perl/Data-Hierarchy-0.21
	>=dev-perl/File-Temp-0.14
	dev-perl/Algorithm-Annotate
	dev-perl/Algorithm-Diff
	>=dev-perl/yaml-0.38
	dev-perl/Regexp-Shellish
	dev-perl/Pod-Escapes
	dev-perl/Pod-Simple
	dev-perl/Clone
	dev-perl/IO-Digest
	dev-perl/File-Type
	dev-perl/TimeDate
	dev-perl/URI
	>=dev-perl/PerlIO-eol-0.13
	>=dev-perl/locale-maketext-lexicon-0.42
	>=dev-perl/Locale-Maketext-Simple-0.12
	dev-perl/Compress-Zlib
	dev-perl/FreezeThaw
	>=dev-perl/Class-Autouse-1.15
	dev-perl/IO-Pager
	crypt? ( app-crypt/gnupg )"

src_unpack () {

	unpack ${A}

	if use crypt
	then
			ewarn Self-tests may cause the installation to fail with USE=crypt!
			einfo 'Try USE="-crypt" emerge -v svk if this happens.'
			ebeep 3
	else
			epatch ${FILESDIR}/svk-${PV}-nognupgtest.patch
			rm ${S}/t/72sign.t

	fi
}
