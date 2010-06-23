# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythnetvision/mythnetvision-0.23_p25065.ebuild,v 1.3 2010/06/23 19:40:46 halcy0n Exp $

EAPI=2

PYTHON_DEPEND="2:2.5"

inherit qt4 mythtv-plugins python

DESCRIPTION="MythTV Plugin for watching internet content"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/pycurl-7.19.0
		>=dev-python/imdbpy-3.8
		>=dev-python/mysql-python-1.2.2
		media-tv/mythtv[python]
		media-plugins/mythbrowser
		www-plugins/adobe-flash"
DEPEND="media-plugins/mythbrowser"

src_install() {
	mythtv-plugins_src_install

	# Fix up permissions
	fperms 755 /usr/share/mythtv/mythnetvision/scripts/*.pl
	fperms 755 /usr/share/mythtv/mythnetvision/scripts/*.py
}
