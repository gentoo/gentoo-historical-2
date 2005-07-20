# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Audio-CD-disc-cover/Audio-CD-disc-cover-0.05.ebuild,v 1.13 2005/07/20 09:18:38 mcummings Exp $

inherit perl-module

MY_P=Audio-CD-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Perl Module needed for app-cdr/disc-cover"
HOMEPAGE="http://homepages.inf.ed.ac.uk/jvanheme/disc-cover.html"
SRC_URI="http://homepages.inf.ed.ac.uk/jvanheme/files/${MY_P}.tar.gz"
IUSE=""
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64 ppc sparc alpha"

DEPEND="${DEPEND}
	>=perl-core/MIME-Base64-2.12
	>=dev-perl/URI-1.10
	>=dev-perl/HTML-Parser-3.15
	>=perl-core/Digest-MD5-2.12
	>=dev-perl/libnet-1.0703-r1
	>=dev-perl/libwww-perl-5.50
	>=media-libs/libcdaudio-0.99.6"
