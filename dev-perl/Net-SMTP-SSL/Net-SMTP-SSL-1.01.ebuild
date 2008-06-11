# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-SMTP-SSL/Net-SMTP-SSL-1.01.ebuild,v 1.8 2008/06/11 16:26:06 nixnut Exp $

MODULE_AUTHOR="CWEST"
inherit perl-module

DESCRIPTION="SSL support for Net::SMTP"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc ~sparc-fbsd x86 ~x86-fbsd"

DEPEND="dev-lang/perl
		virtual/perl-libnet
		dev-perl/IO-Socket-SSL"

mydoc="Changes README"
SRC_TEST="do"
