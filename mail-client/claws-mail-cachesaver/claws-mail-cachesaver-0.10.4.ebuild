# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/claws-mail-cachesaver/claws-mail-cachesaver-0.10.4.ebuild,v 1.3 2008/05/28 01:51:10 halcy0n Exp $

MY_P="${P#claws-mail-}"

DESCRIPTION="Saves the cache regularly to avoid folder rebuild in case of a crash."
HOMEPAGE="http://www.claws-mail.org"
SRC_URI="http://www.claws-mail.org/downloads/plugins/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~sparc ~x86"
IUSE=""
RDEPEND=">=mail-client/claws-mail-2.7.0"

DEPEND="${RDEPEND}
		dev-util/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_install() {
	make DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS

	# kill useless files
	rm -f "${D}"/usr/lib*/claws-mail/plugins/*.{a,la}
}
