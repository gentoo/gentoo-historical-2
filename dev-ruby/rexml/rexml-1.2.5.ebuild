# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Aaron Malone <aaron@munge.net>
# Maintainer: Tools Team <tools@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rexml/rexml-1.2.5.ebuild,v 1.2 2002/04/28 04:33:39 seemant Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="Ruby Electric XML"
SRC_URI="http://www.germane-software.com/~ser/Software/archives/${PN}_${PV}.tgz"
HOMEPAGE="http://www.germane-software.com/~ser/Software/rexml/"
DEPEND=">=dev-lang/ruby-1.6.0"

src_unpack () {
	unpack ${A}
	cd ${S}/bin
	patch < ${FILESDIR}/${P}-gentoo.diff || die
}

src_install () {
	PORTAGETMP=${D} ruby bin/install.rb
}
