# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: George Shapovalov <georges@its.caltech.edu>
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MP3-Info/MP3-Info-1.01-r1.ebuild,v 1.1 2002/05/05 18:47:51 seemant Exp $

. /usr/portage/eclass/inherit.eclass || die
inherit perl-module

S="${WORKDIR}/${P}"
DESCRIPTION="A Perl module to manipulate/fetch info from MP3 files"
SRC_URI="http://prdownloads.sourceforge.net/mp3-info/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/mp3-info/"
