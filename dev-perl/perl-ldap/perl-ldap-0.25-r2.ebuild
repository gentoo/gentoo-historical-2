# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/perl-ldap/perl-ldap-0.25-r2.ebuild,v 1.2 2003/09/08 12:23:08 mcummings Exp $

inherit perl-module

DESCRIPTION="A collection of perl modules which provide an object-oriented interface to LDAP servers."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://perl-ldap.sourceforge.net"
IUSE=""
SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 alpha"

DEPEND="${DEPEND} dev-perl/Convert-ASN1"
