# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/hwdata-redhat/hwdata-redhat-0.187.ebuild,v 1.1 2006/09/05 21:07:32 dberkholz Exp $

inherit flag-o-matic rpm

# Revision of the RPM. Shouldn't affect us, as we're just grabbing the source
# tarball out of it
RPMREV="1"

MY_P="${P/-redhat}"
DESCRIPTION="Hardware identification and configuration data"
HOMEPAGE="http://fedora.redhat.com/projects/config-tools/"
SRC_URI="mirror://fedora/development/source/SRPMS/${MY_P}-${RPMREV}.src.rpm"
LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE=""
RDEPEND=">=sys-apps/module-init-tools-3.2
	!sys-apps/hwdata-gentoo"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MY_P}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
